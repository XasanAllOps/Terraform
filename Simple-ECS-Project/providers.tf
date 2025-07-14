terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
      # --- pinned version, consistent & predictable builds, avoids unexpected breaking changes and simplifies troubleshooting.
    }
  }
}

provider "aws" {
  region = local.region
}