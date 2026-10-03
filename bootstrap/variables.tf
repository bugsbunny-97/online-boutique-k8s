variable "region" {
  description = "AWS region for the state bucket"
  type        = string
  default     = "ap-south-1"
}

variable "project" {
  description = "Project name, used in bucket naming and tags"
  type        = string
  default     = "eks-terraform"
}
