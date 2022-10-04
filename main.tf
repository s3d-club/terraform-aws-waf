locals {
  block_unknowns         = try(var.ip_whitelist[0] != "0.0.0.0/0", false)
  block_unknowns_set     = local.block_unknowns ? [1] : []
  not_block_unknowns_set = local.block_unknowns ? [] : [1]
  name                   = module.name.prefix
  redirect_keys          = keys(var.redirects)
  tags                   = module.name.tags
}

module "name" {
  source = "github.com/s3d-club/terraform-external-name?ref=v0.1.2"

  path    = path.module
  context = var.name_prefix
  tags    = var.tags
}

resource "aws_cloudwatch_log_group" "this" {
  name       = "aws-waf-logs-${var.name_prefix}"
  tags       = local.tags
  kms_key_id = var.kms_key_arn
}

resource "aws_wafv2_ip_set" "blacklist" {
  addresses          = var.ip_blacklist
  ip_address_version = "IPV4"
  name               = "${local.name}-blacklist"
  scope              = "CLOUDFRONT"
  tags               = local.tags
}

resource "aws_wafv2_ip_set" "whitelist" {
  count = local.block_unknowns ? 1 : 0

  addresses          = var.ip_whitelist
  ip_address_version = "IPV4"
  name               = local.name
  scope              = "CLOUDFRONT"
  tags               = local.tags
}

resource "aws_wafv2_web_acl" "this" {
  name  = local.name
  scope = "CLOUDFRONT"
  tags  = local.tags

  custom_response_body {
    key          = "default"
    content_type = "APPLICATION_JSON"

    content = jsonencode({
      waf = "blocked"
    })
  }

  custom_response_body {
    key          = "blacklisted"
    content_type = "APPLICATION_JSON"

    content = jsonencode({
      waf = "blacklisted"
    })
  }

  dynamic "default_action" {
    for_each = local.block_unknowns_set

    content {
      block {
        custom_response {
          response_code            = 412
          custom_response_body_key = "default"
        }
      }
    }
  }

  dynamic "default_action" {
    for_each = local.not_block_unknowns_set

    content {
      allow {}
    }
  }

  dynamic "rule" {
    for_each = local.block_unknowns ? [1] : []

    content {
      name     = "whitelisted-ip"
      priority = 2

      action {
        allow {}
      }

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.whitelist[0].arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = "whitelist-ip"
        sampled_requests_enabled   = false
      }
    }
  }

  dynamic "rule" {
    for_each = var.redirects

    content {
      name     = "redirect-${replace(rule.key, "/", "--")}"
      priority = (local.block_unknowns ? 3 : 2) + index(local.redirect_keys, rule.key)

      action {
        block {
          custom_response {
            response_code = 301

            response_header {
              name  = "location"
              value = rule.value
            }
          }
        }
      }

      statement {

        byte_match_statement {
          positional_constraint = "STARTS_WITH"
          search_string         = "/${rule.key}"

          field_to_match {

            uri_path {}
          }

          text_transformation {
            priority = 0
            type     = "NONE"
          }
        }
      }


      visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = "block-blacklist-ip"
        sampled_requests_enabled   = false
      }
    }
  }

  rule {
    name     = "blacklisted-ip"
    priority = 1

    action {
      block {
        custom_response {
          response_code            = 412
          custom_response_body_key = "blacklisted"
        }
      }
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.blacklist.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "block-blacklist-ip"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "manged-ip"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  log_destination_configs = [aws_cloudwatch_log_group.this.arn]
  resource_arn            = aws_wafv2_web_acl.this.arn
}
