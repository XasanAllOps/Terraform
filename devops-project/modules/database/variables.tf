variable "vpc_id" {}

variable "alb_security_group" {}

variable "db_name" {}

variable "db_username" {
  type      = string
  sensitive = true

}

variable "db_password" {
  type      = string
  sensitive = true

}

variable "db_subnet_group_name" {}
