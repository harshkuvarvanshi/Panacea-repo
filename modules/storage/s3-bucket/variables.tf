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
  #default = ""   
}