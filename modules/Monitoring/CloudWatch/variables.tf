variable "log_group_name" {
  type = string
}

variable "retention_days" {
  type    = number
  default = 7
}

variable "environment" {
  type = string
}

variable "firehose_arn" {
  type = string
}