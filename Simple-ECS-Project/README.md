# A Simple ECS Project

This project is a hands-on exploration of how ECS orchestrates containerized applications on AWS.  

My goal was to:

- Learn how the key `ECS` components work together (`cluster`, `task`, `service`)
- Implement that architecture cleanly with community-maintained terrafrom modules for simplicity
- Push images to `ECR` and deploy them with ECS Fargate

The focus is on understanding the orchestration flow — not just deploying a container, but seeing how:

- Traffic flows from the load balancer to the container
- Logs and monitoring integrate via CloudWatch

Along the way, I chose to use community-maintained Terraform modules for smooth setup. While these modules abstract away some of the complexity, the emphasis remains on understanding the orchestration flow, and the project is documented thoroughly to serve as a future reference and reusable template — both for myself and others.

---

## Project Components

### 1. **VPC**
Using the `terraform-aws-modules/vpc/aws` module:
- Sets up public and private subnets across 2 availability zones
- Enables NAT Gateway (single, for cost optimization)
- DNS support enabled for ECS tasks

### 2. **ECS Cluster**
Using `terraform-aws-modules/ecs/aws//modules/cluster`:
- ECS Cluster configured to use Fargate
- ECS Exec enabled for debugging and auditing (logs sent to CloudWatch)

### 3. **ECS Service (NGINX)**
Using `terraform-aws-modules/ecs/aws//modules/service`:
- NGINX container deployed from a public image
- Service runs with 2 replicas (Fargate tasks)
- ALB routes HTTP traffic to containers
- Health checks configured for both ALB and container
- Logs pushed to CloudWatch Log Group

### 4. **Application Load Balancer (ALB)**
Using `terraform-aws-modules/alb/aws`:
- Public-facing ALB with listener on port 80
- ALB forwards traffic to target group (ECS containers)
- Security groups configured for internet access

### 5. **ECR (Elastic Container Registry)**

- Used a public image from Amazon ECR (`nginx:1.28.0`)
- **No Docker or custom image builds** were involved
- Can be extended to support:
  - Build your own image locally with Docker
  - Push it to **Amazon ECR (private registry)**
  - Reference that private image in the ECS task definition for a custom deployment
> For now, using a public image keeps the focus on ECS orchestration, but the infrastructure is ready to support private images in the future.

### 6. **IAM Role**
Manually created:
- ECS Task Execution Role to allow pulling images from ECR and sending logs to CloudWatch

### 7. **CloudWatch Logs**
- ECS logs routed to CloudWatch with a short retention (3 days)

---

## 📁 File Structure

```bash
.
├── README.md
└── Terraform/
    ├── alb.tf
    ├── cloudwatch.tf
    ├── ecs.tf
    ├── iam.tf
    ├── locals.tf
    ├── providers.tf
    └── vpc.tf
```

---

## Requirements

To run and deploy this project, make sure you have the following installed and configured:

- **Terraform** (version 1.3 or higher)  
- **AWS CLI** configured with proper credentials and permissions  
- **Docker** (only if you plan to build and push custom images to ECR)  

---

## Key Learning Objectives

- Understand how ECS orchestrates containers using task definitions, services, and clusters
- Learn how to wire ECS with other AWS components like VPC, ALB, IAM, and CloudWatch
- Practice writing modular Terraform code
- Document a working ECS+Terraform pattern that can be used or extended in future projects

---
## How Traffic Flows in This Architecture

Here’s a simple flow of how a user request travels through the infrastructure:

1. A user types the application URL starting with `http://` in their browser. This sends a request to `port 80`, the default port for HTTP traffic.
2. The Application Load Balancer (ALB), which is public-facing and listens on `port 80`, receives the request.
3. The ALB forwards the request to the configured target group.
4. The target group sends the traffic to the Fargate container running the NGINX app, listening on `port 80`.
5. The container processes the request and responds accordingly.

```pgsql
           User (HTTP :80)
                  │
                  ▼
    +----------------------------------+
    |   Application Load Balancer      |
    |   • Public subnet                |
    |   • Listener: HTTP on port 80    |
    +----------------------------------+
                  │
                  ▼
    +----------------------------------+
    |          Target Group            |
    |   • Forwards traffic to port 80  |
    |   • Target type: ip (Fargate)    |
    +----------------------------------+
                  │
                  ▼
    +----------------------------------+
    |     ECS Fargate Task (NGINX)     |
    |   • Container port: 80           |
    |   • Internal in private subnet   |
    +----------------------------------+
```
---
## Why Use Terraform Modules?

For a beginner project, using community-maintained Terraform modules (like `terraform-aws-modules`) offers several advantages:

### ✅ Pros:
- **Reduces complexity**: Abstracts low-level resources into high-level blocks (e.g. VPC, ECS, ALB)
- **Faster development**: Get working infrastructure up and running quickly
- **Battle-tested**: Modules often follow AWS best practices out-of-the-box
- **Great for learning**: Lets you focus on understanding architecture and orchestration flow

### ⚠️ Cons:
- **Black box effect**: May hide lower-level implementation details that are useful to learn
- **External dependency**: Community-maintained modules can change over time
- **Version drift**: Frequent updates may introduce breaking changes or incompatibilities

To avoid issues, it's strongly recommended to pin the module versions — as done in this project — to ensure reproducibility and prevent unexpected behavior due to upstream changes.

> In short: modules are great for learning and prototyping, but it's important to understand what they're doing under the hood if you plan to scale or go to production.

---
## When to Skip Modules and Use Raw Resources

While modules simplify infrastructure, sometimes you want **more fine-grained control** or to learn the inner workings better.

In that case, you can **skip modules entirely** and define everything using raw Terraform `resource` blocks — for example:

```hcl
resource "aws_ecs_cluster" "this" {
  name = "my-cluster"
}
```

This approach gives you:

- Full visibility into AWS resource configuration ✅
- Easier customization for unique requirements ✅
- A deeper understanding of how each component works ✅

However, it is more verbose and slower to develop, which is why this project starts with modules but can evolve towards raw resource definitions as your needs grow.

---
---

## Conclusion

This project serves as a hands-on introduction to deploying containerised applications on AWS using ECS Fargate with Terraform. It highlights how core AWS components — ECS clusters and services, VPC, ALB, IAM roles, and CloudWatch — work together to enable scalable and manageable container orchestration.

By leveraging community Terraform modules, the setup is streamlined without sacrificing a clear understanding of the underlying architecture and traffic flow.

While the current deployment uses a public NGINX image for simplicity, the infrastructure is designed to easily support custom container images and additional enhancements like HTTPS and CI/CD pipelines.

Overall, this project provides a reusable foundation and reference point for future AWS ECS deployments.

---
