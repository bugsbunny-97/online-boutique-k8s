locals {
  cluster_name = "online-boutique"
  azs          = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "${local.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs = local.azs

  # Private: three /20s (4,094 IPs each), because pods consume VPC IPs.
  # Public:  three /24s, starting at netnum 48 so they never overlap private.
  # With a /16 VPC: private = 10.42.0.0/20, 10.42.16.0/20, 10.42.32.0/20
  #                 public  = 10.42.48.0/24, 10.42.49.0/24, 10.42.50.0/24
  private_subnets = [for k in range(3) : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k in range(3) : cidrsubnet(var.vpc_cidr, 8, 48 + k)]

  enable_nat_gateway = true
  single_nat_gateway = true # dev: one NAT instead of one per AZ

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb"                      = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"             = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
