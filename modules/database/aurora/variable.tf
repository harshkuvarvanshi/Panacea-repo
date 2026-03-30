variable "name" {}
variable "environment" {}

variable "vpc_id" {}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "engine" {
  default = "aurora-mysql"
}

variable "engine_version" {
  default = "8.0.mysql_aurora.3.04.0"
}

variable "db_name" {}
variable "db_username" {}
variable "db_password" {}

variable "instance_class" {
  default = "db.t3.medium"
}

variable "instance_count" {
  default = 1
}

variable "backup_retention_period" {
  default = 7
}

variable "backup_window" {
  default = "07:00-09:00"
}

variable "skip_final_snapshot" {
  default = true
}