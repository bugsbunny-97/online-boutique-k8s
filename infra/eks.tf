module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.26.0"

  name               = local.cluster_name
  kubernetes_version = var.kubernetes_version

  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  endpoint_public_access       = true
  endpoint_public_access_cidrs = var.api_access_cidrs
  enable_irsa                  = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    general = {
      name                     = "${local.cluster_name}-general"
      instance_types           = [var.node_instance_type]
      min_size                 = var.node_min_size
      desired_size             = var.node_desired_size
      max_size                 = var.node_max_size
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
