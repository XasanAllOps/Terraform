# Terraform 2-Tier Architecture on AWS

This project provisions a **2-tier architecture** on AWS using Terraform. It’s built with modular components (network, compute, and load balancer), and is designed for scalability, reusability, and clarity.

---

## Project Structure

```
Terraform/
├── 2-Tier-Architecture/
│   ├── modules/
│   │   ├── compute/
│   │   ├── loadbalancer/
│   │   └── network/
│   ├── environment/
│   │   ├── install_apache.sh   
│   │   ├── main.tf              
│   │   ├── stage.tfvars            
│   │   └── variables.tf            
├── README.md
└── .gitignore
```
## What This Deploys

- **VPC** with public and private subnets
- **Internet Gateway** and **NAT Gateway**
- **Security Groups** for application and ALB
- **Auto Scaling Group** with a Launch Template
- **Application Load Balancer**
- **User data** to install Apache on EC2 instances

## Modules Breakdown

### `network`
- Creates a VPC, subnets (public/private)
- Sets up route tables, Internet Gateway (IGW), Network Address Translation (NAT) Gateway, Elastic IP (EIP) Address and Route Tables with proper associations to subnet.

### `loadbalancer`
- Provisions an Application Load Balancer and security group
- Configures a listener and target group

### `compute`
- Launch Template for EC2 instances
- Auto Scaling Group with ALB attachment
- Apache installation via `install_apache.sh`

## Features
- Modularized infrastructure  
- Auto Scaling Group with Launch Templates  
- Application Load Balancer  
- NAT Gateway & Internet Gateway  
- Apache installed via `install_apache.sh`  
- Separate environment config via `staging.tf`  

## Requirements
- Terraform 1.0+  
- AWS CLI configured  
- An existing key pair in AWS EC2 (`key_name`)  

## Notes
- Defaults to region `ANY YOU CHOOSE`  
- User data installs Apache and prints hostname  
- Best used in a non-production/staging AWS account 

## How to Use

### 1. Clone the repository

```bash
git clone git@github.com:XasanAllOps/Terraform.git
cd Terraform/2-Tier-Architecture
```
### 2. Initialize Terraform
```bash
terraform init
```
### 3. Format Terraform
```bash
terraform fmt
```
### 4. Terraform Plan
```bash
terraform plan -var-file="environment/stage.tfvars"
```
### 5. Terraform Apply
```bash
terraform apply -var-file="environment/stage.tfvars"
```
### 6. Terraform Destroy
```bash
terraform destroy -var-file="environment/stage.tfvars"
```