output "role_arn" {
  description = "IAM role ARN (used in OpenSearch data access policy)"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "IAM role name"
  value       = aws_iam_role.this.name
}

output "instance_profile_name" {
  description = "IAM instance profile name (attach to EC2 instances)"
  value       = aws_iam_instance_profile.this.name
}

output "instance_profile_arn" {
  description = "IAM instance profile ARN"
  value       = aws_iam_instance_profile.this.arn
}
