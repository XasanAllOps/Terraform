# -- CHILD COMPUTE MODULE 🔑 --

data "aws_ami" "main" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

locals {
  latest_ami = data.aws_ami.main.id
}

resource "aws_security_group" "app_tier" {
  name        = "app_tier_security_group"
  description = "security group for app tier instances allowing inbound SSH (port 22) and HTTP (port 80) traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "app_tier" {
  name_prefix            = "${var.environment}-launch-template"
  instance_type          = var.instance_type
  image_id               = local.latest_ami
  vpc_security_group_ids = [aws_security_group.app_tier.id]
  key_name               = var.key_name
  user_data              = filebase64("install_apache.sh")
}

resource "aws_autoscaling_group" "app_tier" {
  name                = "${var.environment}-asg"
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2
  vpc_zone_identifier = var.private_subnets
  target_group_arns   = [var.alb_target_group_arn]

  launch_template {
    id      = aws_launch_template.app_tier.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "app_tier" {
  autoscaling_group_name = aws_autoscaling_group.app_tier.id
  lb_target_group_arn    = var.alb_target_group_arn
}
