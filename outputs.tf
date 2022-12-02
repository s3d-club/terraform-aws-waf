output "arn" {
  value = aws_wafv2_web_acl.this.arn

  description = <<-END
    The ARN for the `aws_wafv2_web_acl`.
    END
}
