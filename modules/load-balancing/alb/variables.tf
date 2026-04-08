# =================================
# Variables
# =================================
variable "name" {
  description = "ALB name" 
  type        = string               # Name of the Application Load Balancer
}

variable "environment" {
  description = "Environment"
  type        = string               # Environment (e.g., dev, prod)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string               # VPC where ALB will be created
}

variable "subnets" {
  description = "Public subnets for ALB"
  type        = list(string)         # List of public subnets for ALB placement
}

variable "security_groups" {
  description = "ALB security group"
  type        = list(string)         # Security groups attached to ALB
}

variable "instance_ids" {
  description = "DFB EC2 instance IDs"
  type        = list(string)        # Backend EC2 instances to attach
}

variable "target_group_name" {
  description = "Target group name"
  type        = string               # Name of target group for routing traffic
}

variable "logs_bucket_name" {
  type = string                     # S3 bucket name for ALB access logs (optional)
}