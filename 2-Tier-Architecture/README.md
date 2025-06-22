# 🏗️ Terraform 2-Tier Architecture on AWS

This project provisions a **2-tier architecture** on AWS using Terraform. It’s built with modular components (network, compute, and load balancer), and is designed for scalability, reusability, and clarity.

---

## 📁 Project Structure

Terraform/
├── 2-Tier-Architecture/
│ ├── modules/
│ │ ├── compute/
│ │ ├── loadbalancer/
│ │ └── network/
│ ├── environment/
│ │ └── staging.tf
│ ├── install_apache.sh
│ ├── main.tf
│ └── variables.tf 
├── README.md
└── .gitignore

