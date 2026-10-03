module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.26.0"

  name               = local.cluster_name
  kubernetes_version = var.kubernetes_version

  endpoint_public_access = true
  enable_irsa            = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    general = {
      name                     = "${local.cluster_name}-general"
      instance_types           = ["t3.small"]
      min_size                 = 1
      desired_size             = 2
      max_size                 = 3
      iam_role_name            = "${local.cluster_name}-general-node"
      iam_role_use_name_prefix = false
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
