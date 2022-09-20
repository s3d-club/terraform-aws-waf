locals {
  block_unknowns      = try(var.ip_whitelist[0] != "0.0.0.0/0", false)
  block_unknwons_set  = local.block_unknowns ? [1] : []
  block_unknwons_set_ = local.block_unknowns ? [] : [1]
}

resource "aws_wafv2_ip_set" "blacklist" {
  addresses          = var.ip_blacklist
  ip_address_version = "IPV4"
  name               = var.name
  scope              = "CLOUDFRONT"
  tags               = var.tags
}

resource "aws_wafv2_ip_set" "whitelist" {
  count = local.block_unknowns ? 1 : 0

  addresses          = var.ip_whitelist
  ip_address_version = "IPV4"
  name               = var.name
  scope              = "CLOUDFRONT"
  tags               = var.tags
}

resource "aws_wafv2_web_acl" "this" {
  name  = var.name
  scope = "CLOUDFRONT"
  tags  = var.tags

  dynamic "default_action" {
    for_each = local.block_unknwons_set

    content {
      block {}
    }
  }

  dynamic "default_action" {
    for_each = local.block_unknwons_set_

    content {
      allow {}
    }
  }

  rule {
    name     = "blacklisted-ip"
    priority = 1

    action {
      block {}
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
    for_each = local.block_unknowns ? [1] : []

    content {
      name     = "block-unknown-ip"
      priority = 3

      action {
        block {}
      }

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.whitelist.arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = "unknown-ip"
        sampled_requests_enabled   = false
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "manged-ip"
    sampled_requests_enabled   = false
  }
}
