resource "aws_iam_role" "ecs_execution_role" {
  name = "ecsTaskExecutionRole"

  # --- Specifies ECS as the trusted entity allowed to assume the role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# --- Attaches permissions required by ECS to pull images from ECR and push logs to CloudWatch Logs.
resource "aws_iam_role_policy_attachment" "ecs_execution_policy_for_role" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

