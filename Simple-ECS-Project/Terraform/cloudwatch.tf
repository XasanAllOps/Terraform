resource "aws_cloudwatch_log_group" "nginx" {
  name              = "/ecs/nginx/task"
  retention_in_days = 3
  tags              = local.tags
}
