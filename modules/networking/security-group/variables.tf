variable "name" {
  description = "Security group name"
  type        = string
}

variable "description" {
  description = "Security group description"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

# Supports both CIDR and SG-to-SG ingress
# For CIDR rules: set cidr_blocks, leave source_security_group_id null
# For SG-to-SG:  set source_security_group_id, leave cidr_blocks empty []
variable "ingress_rules" {
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    description              = string
    cidr_blocks              = optional(list(string), [])
    source_security_group_id = optional(string, null)
  }))
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}
