
 
variable "instance_name" {}  # Name of the EC2 instance (panacea-rig)

 variable "instance_type" {}# Instance type (t3.medium)

 variable "subnet_id" {}# Subnet where EC2 will be launched (public subnet)

 variable "vpc_id" {}# VPC ID (used for security group)
 
variable "my_ip" {}# Your IP for SSH access (important for security)