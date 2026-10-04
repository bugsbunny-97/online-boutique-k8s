terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # EKS module v21 and VPC module v6 both require AWS provider v6.
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0" # v3 uses `kubernetes = { ... }` attribute syntax
    }
  }
}
