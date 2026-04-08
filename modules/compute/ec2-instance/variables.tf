# ====================================
# Input variables for configuring EC2 instance properties
# ====================================

variable "instance_name" {
  type = string            # Name tag for the EC2 instance
}

variable "ami_id" {
  type = string            # AMI ID (OS image for instance)
}

variable "instance_type" {
  type = string            # EC2 instance type (e.g., t2.micro)
}

variable "subnet_id" {
  type = string            # Subnet ID where instance will be deployed
}

variable "security_group_ids" {
  type = list(string)     # List of security groups (firewall rules)
}

variable "associate_public_ip" {
  type = bool              # Whether to assign a public IP
}

variable "volume_size" {
  type = number             # Root volume size (in GB)
}

variable "key_name" {
  type = string            # SSH key pair name for login acces
}

# ── NEW: IAM Instance Profile ─────────────────────────────
# Pass instance_profile_name from iam/ec2-role module output.
# Set to null for instances that don't need AWS API access.
variable "iam_instance_profile_name" {
  description = "IAM instance profile name to attach (null = no profile)"
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
