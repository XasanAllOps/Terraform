# -- PRODUCTION ✍🏽 -- #

environment         = "PROD"
aws_region          = "eu-west-2"
instance_type       = "m5.large"
ec2_instance        = "Nginx"
key_name            = "my_key"
vpc_name            = "VPC"
vpc_cidr            = "192.168.0.0/16"
public_subnet_cidr  = ["192.168.1.0/24", "192.168.2.0/24"]
private_subnet_cidr = ["192.168.3.0/24", "192.168.4.0/24"]
listener_protocol   = "HTTP"
tg_protocol         = "HTTP"
listener_port       = 80
tg_port             = 80
tg_attach_port      = 80
db_name              = "RDS_DB_PROD"
rds_subnet_group_name = "rds_subnetgroup_prod"
