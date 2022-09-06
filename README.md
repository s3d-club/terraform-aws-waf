# AWS Open Egress
Terraform module for open AWS Egress.

## Associated Documents
Please read our [LICENSE][lice], [CONTRIBUTING][cont], and [CHANGES][chge]
documents before working in this project and anytime they are updated.

## Overview
This module is an opinionated wrapper around an [aws security group][awss]
resource.

We enforce the following:
- Our conventions for name, description, and tagging
- Reduced arguments and attributes

[chge]: ./CHANGES.md
[cont]: ./CONTRIBUTING.md
[lice]: ./LICENSE.md
[awss]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
