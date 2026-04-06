variable "name" {
  type = string
}

variable "bucket_domain_name" {
  type = string
}

# IMPORTANT (for secure S3 access)
variable "origin_access_identity" {
  type        = string
  description = "CloudFront Origin Access Identity"
  default     = ""
}

variable "logs_bucket_domain_name" {
  type = string
  default = ""
}