variable "ip_blacklist" {
  default = []
  type    = list(string)

  description = <<-END
    a list of IP addresses that will be blocked.
    https://go.s3d.club/tf/waf#ip_blacklist
    END
}

variable "ip_whitelist" {
  default = ["0.0.0.0/0"]
  type    = list(string)

  description = <<-END
    a list of IP addresses that will be allowed.
    https://go.s3d.club/tf/waf#ip_whitelist
    END
}

variable "kms_key_arn" {
  type = string

  description = <<-END
    KMS Key ARN
    https://go.s3d.club/tf/waf#kms_key_arn
    END
}

variable "name_prefix" {
  type = string

  description = <<-END
    a prefix for resource names.
    https://go.s3d.club/tf/waf#name_prefix
    END
}

variable "redirects" {
  default = {}
  type    = map(string)

  description = <<-END
    a map of path with urls for 301 redirects.
    https://go.s3d.club/waf#redirects
    END
}

variable "tags" {
  default = {}
  type    = map(string)

  description = <<-END
    A map of tags for resources.
    https://go.s3d.club/waf#redirects
    END
}
