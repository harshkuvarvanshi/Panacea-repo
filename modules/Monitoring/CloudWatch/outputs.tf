output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.this.name
}

output "log_group_arn" {
  description = "CloudWatch log group ARN"
  value       = aws_cloudwatch_log_group.this.arn
}

output "cloudwatch_firehose_role_arn" {
  description = "IAM role ARN that CloudWatch uses to write to Firehose"
  value       = aws_iam_role.cloudwatch_to_firehose.arn
}
