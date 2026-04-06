variable "instance_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "associate_public_ip" {
  type = bool
}

variable "volume_size" {
  type = number
}

variable "key_name" {
  type = string
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
