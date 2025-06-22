# -- STAGING ENVIRONMENT ✍🏽 -- #

environment         = "stage"
aws_region          = "eu-west-2"
instance_type       = "t2.micro"
key_name            = "id_rsa"
vpc_name            = "vpc"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
listener_port       = 80
listener_protocol   = "HTTP"
tg_port             = 80
tg_protocol         = "HTTP"
