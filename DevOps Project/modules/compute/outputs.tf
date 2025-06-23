output "instance_id" {
  value = aws_instance.main
}

output "web_tier_sg" {
  value = aws_security_group.web_tier.id
}