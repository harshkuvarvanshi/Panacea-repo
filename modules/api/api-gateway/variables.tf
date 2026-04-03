# ==========================================================
# API NAME
# ==========================================================
variable "name" {
  description = "API Gateway name"
  type        = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "alb_listener_arn" {
  type = string
}