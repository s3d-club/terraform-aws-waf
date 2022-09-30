variable "ip_blacklist" {
  default = []
  type    = list(string)

  description = <<-END
    The IP Blacklist 

    The IP Blacklist defines a set of IP addresses that will be trusted.

    For cases where a given IP is in both the IP Whitelist and the IP Blacklist
    requests will be blocked because the IP Blacklist takes precidence.
    END
}

variable "ip_whitelist" {
  default = ["0.0.0.0/0"]
  type    = list(string)

  description = <<-END
    The IP Whitelist

    The IP Whitelist defines a set of IP addresses that will be trusted.

    For cases where a given IP is in both the IP Whitelist and the IP Blacklist
    requests will be blocked because the IP Blacklist takes precidence.
    END
}

variable "name_prefix" {
  type = string

  description = <<-END
    The name of the WAF resource

    The WAF resource defined by this module will have this name. The names of
    associated resources incorporate the name of the WAF resource as a prefix in
    cases where they need unique names.
    END
}

variable "tags" {
  default = {}
  type    = map(string)

  description = <<-END
    The tags for resources

    This module will include these tags on all resources.
    END
}
