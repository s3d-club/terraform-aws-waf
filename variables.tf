variable "ip_blacklist" {
  default = []
  type    = list(string)

  description = <<-EOT
    A list of IP addresses that will be blocked.
    EOT
}

variable "ip_whitelist" {
  default = ["0.0.0.0/0"]
  type    = list(string)

  description = <<-EOT
    A list of IP addresses that will be allowed.
    EOT
}

variable "kms_key_arn" {
  type = string

  description = <<-EOT
    A KMS Key ARN.
    EOT
}

variable "name_prefix" {
  type = string

  description = <<-EOT
    A prefix for resource names.
    EOT
}

variable "redirects" {
  default = {}
  type    = map(string)

  description = <<-EOT
    A map of path with urls for 301 redirects.
    EOT
}

variable "tags" {
  default = {}
  type    = map(string)

  description = <<-EOT
    A map of tags for resources.
    EOT
}
