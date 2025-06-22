output "alb_sg" {
  value = aws_security_group.alb.id
}

output "alb_tg_arn" {
  value = aws_lb_target_group.target_group.arn
}
