variable "name" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}

variable "allowed_cidr_blocks" {
  type = list(string)
}

variable "db_name" {}
variable "db_username" {}
variable "db_password" {}