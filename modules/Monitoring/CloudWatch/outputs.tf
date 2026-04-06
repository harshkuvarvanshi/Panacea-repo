# output "log_group_name" {
#   value = aws_cloudwatch_log_group.this.name
# }

output "log_group_name" {
  value = aws_cloudwatch_log_group.ec2_logs.name
}