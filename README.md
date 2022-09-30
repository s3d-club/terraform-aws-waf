# S3D WAF Module
This project defines the S3D Club's Terraform module for AWS Web Application Firewall.

## Also READ
Please read our [LICENSE][lice], [CONTRIBUTING][cont], [CODE-OF-CONDUCT][code],
and [CHANGES][chge] documents before working in this project and anytime they
are update.

## Overview
The Web Application Firewal (WAF) is an important tool in providing services
over the internet in a secure way.

This module manages WAF rules for `ip_blacklist` and `ip_whitelist`.

The `ip_blacklist` takes precidence such that any address matching that rule is
blocked regardless of how it would be considered in the context of the
`ip_whitelist`. For simple sites without strict security rules an initial
depoyment with the default value will be not blacklist any address.

The `ip_whitelist` allows non blacklisted addresses to be granted access to the
site. If the first entry of the list is the default of `0.0.0.0/0` then all
addresses are allowed.

The name and tags for AWS resources are managed by this module such that the
WAF will have a unique name that includes the prefix input. Input tags are
ammended with information about this module's version and the set of tags are
applied to resources.

[chge]: ./CHANGES.md
[code]: ./CODE-OF-CONDUCT.md
[cont]: ./CONTRIBUTING.md
[lice]: ./LICENSE.md
