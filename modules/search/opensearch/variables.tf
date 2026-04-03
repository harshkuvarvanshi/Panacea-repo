variable "name" {
  type = string
}

variable "network_policy_name" {
  type = string
}

variable "access_policy_name" {
  type = string
}

variable "principals" {
  type = list(string)
}