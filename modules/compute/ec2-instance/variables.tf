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

variable "tags" {
  type    = map(string)
  default = {}
}
