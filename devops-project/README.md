# Terraform Multi-Environment Infrastructure

This project demonstrates a robust **Terraform Infrastructure as Code** setup for deploying a scalable, secure two-tier architecture on AWS using modular design and multi-environment separation. It leverages reusable Terraform child modules and GitLab CI/CD for safe, automated infrastructure delivery.

---

## Project Overview

This infrastructure deploys a classic **two-tier web application architecture**:

- **Network layer:** Custom VPC with public and private subnets, NAT gateways, routing tables, and security groups.
- **Load Balancer layer:** AWS Application Load Balancer with target groups and listeners to distribute traffic.
- **Compute layer:** EC2 instances running application code, managed via autoscaling.
- **Database layer:** Managed MySQL RDS instance deployed in private subnets with secure access.

---

## Modular Architecture

The project is structured with **reusable child modules** under the `modules/` directory:

- **network:** Creates the VPC, subnets, internet gateway, NAT gateways, route tables, and subnet groups for RDS.
- **loadbalancer:** Configures the Application Load Balancer, listeners, target groups, and security groups.
- **compute:** Provisions EC2 instances with appropriate security groups and user data for application setup.
- **database:** Deploys a MySQL RDS instance with secure networking and credentials.

This modular design ensures:

- **Reusability:** Modules can be reused across multiple environments.
- **Maintainability:** Changes to core infrastructure can be managed centrally.
- **Consistency:** All environments follow the same architecture standards.

---

## Environment Separation

Under the `environment/` directory, separate folders exist for each deployment environment:

- `dev/`
- `stage/`
- `prod/`

Each environment folder contains its own Terraform configuration files (`main.tf`, `variables.tf`, `terraform.tfvars`) that **reference the shared modules**. This provides:

- **Environment isolation:** Separate Terraform state files stored remotely in S3 for each environment to avoid conflicts.
- **Configurable parameters:** Environment-specific variables for subnet CIDRs, instance types, database credentials, and more.
- **Safe promotion:** Infrastructure changes can be tested in dev and stage before manual approval and deployment in production.

---

## Continuous Integration & Deployment (CI/CD)

This project integrates with **GitLab CI/CD** to automate Terraform workflows:

- **Automated validation:** Every change triggers Terraform validation to catch errors early.
- **Plan generation:** Terraform plans are automatically generated to preview infrastructure changes.
- **Manual apply:** Production deployments require manual approval before applying changes.
- **Environment-specific pipelines:** Pipelines run separately for dev, stage, and prod environments using dedicated state files and variable sets.

**Benefits of CI/CD in this project:**

- **Error reduction:** Automation prevents manual mistakes and enforces best practices.
- **Repeatable deployments:** Ensures consistency across environments.
- **Traceability:** All infrastructure changes are version-controlled and auditable.
- **Collaboration:** Teams can review and approve changes before deployment, improving transparency and quality.

## Additional Details

- The `install_nginx.sh` script is used in the compute module to bootstrap EC2 instances with NGINX.
- Terraform backend state is managed remotely using an S3 bucket with environment-specific keys for safety.
- Security groups are configured to allow controlled access between layers (e.g., ALB to EC2, EC2 to RDS).
- Autoscaling and load balancing ensure availability and scalability of the application tier.

## Getting Started

1. Configure AWS credentials with appropriate permissions.
2. Customize variables in the respective environment folders (`dev`, `stage`, or `prod`).
3. Run Terraform commands within the chosen environment folder:

   ```bash
   terraform init
   terraform plan
   terraform apply --auto-approve
   terraform destroy --auto-approve

## Conclusion

This project provides a clean, scalable foundation for managing AWS infrastructure using Terraform modules and CI/CD best practices. It demonstrates how to maintain multiple environments safely and efficiently while enabling fast, reliable infrastructure delivery.

## Credits

This project was inspired by the work of DeenEngineers community
Big thanks to them for the valuable guidance and foundational ideas that helped shape this project.
