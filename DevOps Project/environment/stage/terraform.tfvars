# -- STAGING ✍🏽 -- #

environment         = "STAGE"
aws_region          = "eu-west-2"
instance_type       = "t2.medium"
ec2_instance        = "Nginx"
key_name            = "my_key"
vpc_name            = "VPC"
vpc_cidr            = "172.31.0.0/16"
public_subnet_cidr  = ["172.31.0.0/20", "172.31.16.0/20"]
private_subnet_cidr = ["172.31.32.0/20", "172.31.64.0/20"]
listener_protocol   = "HTTP"
tg_protocol         = "HTTP"
listener_port       = 80
tg_port             = 80
tg_attach_port      = 80
db_name              = "RDS_DB_STAGE"
rds_subnet_group_name = "rds_subnetgroup_stage"