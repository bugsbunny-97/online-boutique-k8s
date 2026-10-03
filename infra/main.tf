# Day 1 sanity check: proves the provider, credentials and remote state all work.
# VPC and EKS resources are added on Days 3-4.
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}
