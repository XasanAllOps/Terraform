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

resource "aws_instance" "main" {
  count                  = 2
  ami                    = local.latest_ami
  instance_type          = var.instance_type
  subnet_id              = element(var.public_subnets, count.index)
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_tier.id]
  user_data              = var.user_data

  tags = {
    Name = "${var.ec2_instance} #${count.index + 1} - ${var.environment}"
  }
}

resource "aws_security_group" "web_tier" {
  name   = "web_tier_security_group"
  vpc_id = var.vpc_id

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