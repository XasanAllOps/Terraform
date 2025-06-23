resource "aws_security_group" "alb" {
  name        = "alb_security_group"
  description = "Controls access to the ALB"
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
  load_balancer_type = "application"
  internal           = false
  idle_timeout       = 100
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  depends_on        = [aws_lb_target_group.target_group]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

}

resource "aws_lb_target_group" "target_group" {
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id
}

  resource "aws_lb_target_group_attachment" "tg_attachment_test" {
  count            = length(var.instance_target_id)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.instance_target_id[count.index].id
  port             = var.target_group_attach_port
}
