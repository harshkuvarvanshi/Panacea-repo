variable "name" {
  description = "ALB name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnets" {
  description = "Public subnets for ALB"
  type        = list(string)
}

variable "security_groups" {
  description = "ALB security group"
  type        = list(string)
}

variable "instance_ids" {
  description = "DFB EC2 instance IDs"
  type        = list(string)
}

variable "target_group_name" {
  description = "Target group name"
  type        = string
}