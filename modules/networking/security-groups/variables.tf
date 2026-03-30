variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "vpc_id" {
  type = string
  # 👉 Dummy abhi, later dependency se
}

variable "ingress_rules" {
  type = list(any)
}

# variable "ingress_rules" {
#   type = list(object({
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = optional(list(string))
#     sg_id       = optional(string)
#   }))
# }

variable "egress_rules" {
  type = list(any)
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}