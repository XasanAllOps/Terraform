module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.17.0"

  name                       = "alb-ecs"
  load_balancer_type         = "application"
  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false

  # --- Listener 🎧: listens on port 80, uses HTTP protocol and forwards the requests to the target group called 'nginx'
  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "nginx"
      }
    }
  }
  # --- Security group 🔐 ingress/egress for Application Load Balancer (ALB)
  security_group_ingress_rules = {
    all_http = {
      description = "Allow all inbound requests from Port 80 via ALB"
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  security_group_egress_rules = {
    all = {
      description = "Allow all outbound traffic"
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  # --- Target Group 🎯: Will connect the ALB to the running containers
  target_groups = {
    nginx = {
      name_prefix       = "nginx-"
      backend_protocol  = "HTTP" # --- The protocol the ECS container listens on internally
      backend_port      = 80     # --- The port that your container (App) is listening on
      target_type       = "ip"   # --- The target_type determines what the target group will register (ip = fargate/ instance = EC2) | 'target_id' if 'target_type' = 'instance'
      create_attachment = false

      healthCheck = { # --- Configures ALB health checks for target groups to see if healthy and can receive traffic
        enabled             = true
        path                = "/"   # --- Endpoint the ALB uses to ping the app
        matcher             = "200" # --- What the status code indicates hleath (usually 200)
        interval            = 30    # --- Time between health checks (seconds)
        timeout             = 5     # --- Max time ALB waits for response 
        healthy_threshold   = 2     # --- How many successful checks to mark as healthy
        unhealthy_threshold = 2     # --- How many failures to mark as unhealthy
      }
    }
  }

  tags = local.tags
}
