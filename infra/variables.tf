variable "region" {
  description = "AWS region for the cluster"
  type        = string
  default     = "ap-south-1"
}

variable "project" {
  description = "Project name used in resource names and tags"
  type        = string
  default     = "eks-terraform"
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (subnet math in vpc.tf assumes a /16). Use a unique range; 10.0.0.0/16 often conflicts with default AWS networking in the account."
  type        = string
  default     = "10.42.0.0/16"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version. AWS requires upgrades one minor version at a time; if the cluster is on 1.33, move to 1.34 before 1.35."
  type        = string
  default     = "1.33"
}

variable "node_instance_type" {
  description = "Instance type for the managed node group"
  type        = string
  default     = "t3.small"
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 3
}

variable "api_access_cidrs" {
  description = "CIDRs allowed to reach the public EKS API endpoint. Restrict to your IP, e.g. [\"203.0.113.10/32\"]"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
