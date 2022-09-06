data "aws_vpc" "this" {
  default = true
}

resource "aws_security_group" "this" {
  name_prefix = "unrestricted-egress-"
  description = "Unrestricted Egress"
  vpc_id      = data.aws_vpc.this.id

  egress {
    description      = "Unrestricted Egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.cidr_blocks
    ipv6_cidr_blocks = var.ipv6_cidr_blocks
  }
}
