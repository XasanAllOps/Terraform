# -- CHILD LOADBALANCER MODULE 🔑 --

resource "aws_security_group" "alb" {
  name        = "alb_security_group"
  description = "enable access on port 80"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "loadbalancer" {
  name               = "two-tier-loadbalancer"
  load_balancer_type = "application"
  internal           = false
  idle_timeout       = 200
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb.id]

  depends_on = [var.asg_app_tier]
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  #Required 👇🏽
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "two-tier-loadbalancer-tg"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id
}

