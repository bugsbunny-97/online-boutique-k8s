locals {
  cluster_name       = "online-boutique"
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs = local.availability_zones

  private_subnets = [for i in range(length(local.availability_zones)) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets  = [for i in range(length(local.availability_zones)) : cidrsubnet(var.vpc_cidr, 8, i + length(local.availability_zones))]

  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    Terraform                                     = "true"
    Environment                                   = "dev"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}
