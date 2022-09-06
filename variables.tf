variable "cidr_blocks" {
  default     = ["0.0.0.0/0"]
  description = "CIDR for Ingress"
  type        = list(string)
}

variable "ipv6_cidr_blocks" {
  default     = ["::/0"]
  description = "IP6 CIDR for Ingress"
  type        = list(string)
}
