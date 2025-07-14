locals {
  region = "eu-west-1" # --- Ireland
  name   = "nginx"
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
