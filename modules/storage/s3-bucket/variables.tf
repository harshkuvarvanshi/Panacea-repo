variable "name" {
  description = "Bucket name"
  type        = string
}

variable "force_destroy" {
  description = "Bucket delete karne pe objects delete kare ya nahi"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Versioning enable karna hai ya nahi"
  type        = bool
  default     = true
}

variable "cloudfront_distribution_arn" {
  type    = string
  default = ""   
}

variable "enable_acl" {
  description = "Enable ACL for logs bucket"
  type        = bool
  default     = false  #for cloudfront acl enable
}

variable "is_logs_bucket" {
  description = "Is this logs bucket?"
  type        = bool
  default     = false
}
variable "enable_cloudfront_access" {
  type    = bool
  default = false

}

variable "enable_alb_logs" {
  description = "Allow ALB to write logs to this bucket"
  type        = bool
  default     = false
}