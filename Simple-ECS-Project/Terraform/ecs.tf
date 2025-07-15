module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "6.0.5"

  name = "ecs_nginx"

  # --- Storing ECS Exec sessions logs
  configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "ecs_shell_logs"
        # --- for security and auditability 🔎: Who connected to the container? What commands did they run? When did they connect and for how long?
      }
    }
  }

  # --- Capacity providers tell ECS how to run tasks: FARGATE? EC2? FARGATE_SPOT?
  default_capacity_provider_strategy = {
    FARGATE = {
      weight = 100 # --- Routes 100% of task placements to Fargate
    }
  }

  tags = local.tags
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "6.0.5"

  name                   = "nginx"
  cluster_arn            = module.ecs_cluster.arn
  desired_count          = 2
  cpu                    = 1024
  memory                 = 2048
  enable_execute_command = true

  container_definitions = {
    nginx = {
      image     = "public.ecr.aws/nginx/nginx:1.28.0"
      essential = true
      portMappings = [
        {
          name          = "nginx"
          containerPort = 80
          # --- hostPort = 8080 | If you want containerPort to be 8080 must have hostPort set to 8080 as well
          protocol      = "tcp"
        }
      ]

      readonlyRootFilesystem = false

      # --- Better lifecycle management, graceful shutdown, and cleanup. The init process acts as PID 1 inside the container, reaping zombie 💀 processes and forwarding signals properly.
      linuxParameters = {
        initProcessEnabled = true
        capabilities = {
          add = []
          drop = [
            "NET_RAW"
          ]
        }
      }

      # --- earlier I set health_check which could have been an error.
      healthCheck = {  
        enabled     = true
        command     = ["CMD-SHELL", "curl -f http://localhost/ || exit 1"]
        # --- originally I set http://localhost:80/ did not work but this way was fine
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }

      log_configuration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.nginx.name
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  }
  load_balancer = {
    # --- This ECS service will be connected to ALB configured prior
    service = {
      target_group_arn = module.alb.target_groups["nginx"].arn
      # --- load_balancer = {service = {container_name}} must match key in container_definitions = {nginx = {}} 🚨
      # --- container_name says which container in the task should handle the traffic
      container_name = "nginx"
      container_port = 80
    }
  }

  subnet_ids       = module.vpc.private_subnets
  assign_public_ip = false

  security_group_ingress_rules = {
    alb_80 = {
      description                  = "Allow traffic from ALB on port 8080"
      from_port                    = 80
      to_port                      = 80
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.alb.security_group_id
    }
  }

  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
}


# --- Gitlab => IAM user for Gitlab (OIDC) | w
# --- DockerFile => builds image => | test trivy (warnings) | => ECR | 
# --- Workflows (Gitlab) => One main pipeline running small workflows