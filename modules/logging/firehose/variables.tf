variable "name" {
  description = "Firehose delivery stream name (e.g. panacea-log-stream)"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "aws_account_id" {
  description = "AWS account ID (used in IAM trust policy ExternalId)"
  type        = string
}

# ── OpenSearch Serverless ─────────────────────────────────
variable "collection_arn" {
  description = "OpenSearch Serverless collection ARN"
  type        = string
}

variable "collection_endpoint" {
  description = "OpenSearch Serverless collection endpoint (https://...)"
  type        = string
}

variable "index_name" {
  description = "OpenSearch index name where logs will be written"
  type        = string
  default     = "panacea-logs"
}

# ── S3 Backup ─────────────────────────────────────────────
variable "backup_bucket_arn" {
  description = "S3 bucket ARN for Firehose backup (use existing artifacts bucket)"
  type        = string
}

variable "collection_name" {
  description = "OpenSearch Serverless collection name (needed for data access policy)"
  type        = string
  default     = "panacea"
}