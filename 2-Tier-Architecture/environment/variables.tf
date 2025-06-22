variable "aws_region" {
  type        = string
  validation {
    condition     = can(regex("^eu-", var.aws_region))
    error_message = "The aws_region value must be a valid region in the europe, starting with \"eu-\"."
  }
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "listener_protocol" {
  type = string
}

variable "listener_port" {
  type = number
}

variable "tg_port" {
  type = number
}

variable "tg_protocol" {
  type = string
}





