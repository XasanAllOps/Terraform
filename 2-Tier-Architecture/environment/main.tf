# -- ROOT MODULE 🔑 -- #

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source              = "../modules/network"
  environment         = var.environment
  vpc_name            = var.vpc_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "loadbalancer" {
  source                = "../modules/loadbalancer"
  public_subnets        = module.network.pub_subnets
  asg_app_tier          = module.compute.asg_app_tier
  vpc_id                = module.network.vpc_id
  listener_port         = var.listener_port
  listener_protocol     = var.listener_protocol
  target_group_port     = var.tg_port
  target_group_protocol = var.tg_protocol
}

module "compute" {
  source               = "../modules/compute"
  vpc_id               = module.network.vpc_id
  alb_security_group   = module.loadbalancer.alb_sg
  private_subnets      = module.network.pri_subnets
  alb_target_group_arn = module.loadbalancer.alb_tg_arn
  environment          = var.environment
  instance_type        = var.instance_type
  key_name             = var.key_name
}