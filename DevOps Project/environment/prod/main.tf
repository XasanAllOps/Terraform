# -- PRODUCTION 🔑 -- #

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "xasan-terraform-bucket"
    key    = "prod/terraform.state"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source              = "../../modules/network"
  environment         = var.environment
  vpc_name            = var.vpc_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  rds_subnet_group_name = var.rds_subnet_group_name
}

module "loadbalancer" {
  source                   = "../../modules/loadbalancer"
  public_subnets           = module.network.pub_subnets
  vpc_id                   = module.network.vpc_id
  listener_port            = var.listener_port
  listener_protocol        = var.listener_protocol
  target_group_port        = var.tg_port
  target_group_protocol    = var.tg_protocol
  instance_target_id       = module.compute.instance_id
  target_group_attach_port = var.tg_attach_port
}

module "compute" {
  source             = "../../modules/compute"
  vpc_id             = module.network.vpc_id
  alb_security_group = module.loadbalancer.alb_sg
  public_subnets     = module.network.pub_subnets
  environment        = var.environment
  instance_type      = var.instance_type
  ec2_instance       = var.ec2_instance
  key_name           = var.key_name
  user_data          = filebase64("../install_nginx.sh")
}

module "database" {
  source               = "../../modules/database"
  vpc_id               = module.network.vpc_id
  alb_security_group   = module.loadbalancer.alb_sg
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_subnet_group_name = module.network.db_subnet_group_name[0]
}