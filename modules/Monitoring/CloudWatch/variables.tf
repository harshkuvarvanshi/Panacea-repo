variable "log_group_name" {
  description = "CloudWatch log group name (e.g. /panacea/ec2/logs)"
  type        = string
}

variable "retention_days" {
  description = "Log retention in days"
  type        = number
  default     = 7
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region (needed for CloudWatch trust policy)"
  type        = string
  default     = "ap-south-1"
}

variable "aws_account_id" {
  description = "AWS account ID (needed for CloudWatch trust policy source condition)"
  type        = string
}

variable "firehose_arn" {
  description = "Kinesis Firehose delivery stream ARN to ship logs to"
  type        = string
}

variable "filter_pattern" {
  description = "CloudWatch Logs filter pattern. Empty string = all logs."
  type        = string
  default     = ""
}
