output "firehose_arn" {
  description = "Kinesis Firehose delivery stream ARN"
  value       = aws_kinesis_firehose_delivery_stream.this.arn
}

output "firehose_name" {
  description = "Kinesis Firehose delivery stream name"
  value       = aws_kinesis_firehose_delivery_stream.this.name
}

output "firehose_role_arn" {
  description = "IAM role ARN that Firehose uses (needs to be added to OpenSearch data access policy)"
  value       = aws_iam_role.firehose.arn
}

output "firehose_error_log_group" {
  description = "CloudWatch log group where Firehose delivery errors are logged"
  value       = aws_cloudwatch_log_group.firehose_errors.name
}
