module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "vpc_ecs"
  cidr = "10.0.0.0/16"

  azs                  = ["eu-west-1a", "eu-west-1b"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  # --- If you do not set 'single_nat_gateway' to true by default it will create one NAT GW per AZ
  # --- From a cost optimisation standpoint, one shared NAT will save costs but the trade-off is possible failure of AZ. As it's a simple project I am happy to accept this.
  tags = local.tags
}
