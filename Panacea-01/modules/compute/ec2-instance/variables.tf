# Instance name (rig / bastion / backend)
variable "instance_name" {}

# Instance type (t3.micro / t3.medium)
variable "instance_type" {}

# Subnet ID (public or private)
variable "subnet_id" {}

# VPC ID
variable "vpc_id" {}

# Whether to assign public IP
variable "associate_public_ip" {
  type = bool
}

# Root volume size
variable "volume_size" {}

# Ingress rules (flexible for all cases)
variable "ingress_rules" {
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
    description     = string
  }))
}

# User data (optional)
variable "user_data" {
  default = ""
}