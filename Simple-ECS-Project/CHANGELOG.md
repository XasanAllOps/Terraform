# CHANGELOG 📜  
All notable changes to this project will be documented here 🙌🏽

## [1.0.0]

### Added ➕  
- Initial release of a Terraform-based ECS infrastructure project using community-maintained Terraform AWS modules to provision and manage core AWS resources.  
- Automated setup of networking (VPC with public/private subnets across multiple AZs and a NAT Gateway), ECS cluster with Fargate capacity provider, and an ECS service running NGINX containers.  
- Integrated Application Load Balancer (ALB) for routing HTTP traffic to ECS tasks, with health checks and secure access controlled by appropriate security groups.  
- IAM roles and policies configured to allow ECS tasks to pull container images from ECR and send logs to CloudWatch.  
- Centralized logging with CloudWatch Logs including retention policies and container-level logging configuration via the awslogs driver.

### Updated 🔄  
- 📝 README.md with detailed project overview, architecture components, and learning objectives.
- ⚠️ Further refinements to README might still be needed.