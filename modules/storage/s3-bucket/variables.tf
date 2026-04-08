variable "name" {
  description = "Bucket name"
  type        = string
}

variable "force_destroy" {
  description = "Bucket delete karne pe objects delete kare ya nahi"
  type        = bool
  default     = false         # If true, deletes all objects when bucket is destroyed
}

variable "versioning_enabled" {
  description = "Versioning enable karna hai ya nahi"
  type        = bool
  default     = true         # Enables versioning for data recovery
}

variable "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN (required only for frontend bucket with OAC). Leave null for all other buckets."
  type        = string
  default     = null           # Used to allow only specific CloudFront access
}

variable "enable_acl" {
  description = "Enable ACL or not"
  type        = bool
  default     = false            # Controls whether ACL-based access is allowed
}

variable "enable_alb_logs" {
  description = "Enable ALB logging"
  type        = bool
  default     = false            # Enables policies for ALB/CloudFront log storage
}