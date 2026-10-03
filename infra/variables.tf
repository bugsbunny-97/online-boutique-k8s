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
