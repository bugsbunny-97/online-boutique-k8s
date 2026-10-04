resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = local.alb_sa_namespace
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "3.5.0" # chart and controller version; keep in sync with the IAM policy file

  # Helm needs working nodes (and the role) before the controller pods can start.
  depends_on = [
    module.eks,
    aws_iam_role_policy_attachment.alb_controller,
  ]

  values = [yamlencode({
    clusterName = module.eks.cluster_name
    region      = var.region
    vpcId       = module.vpc.vpc_id

    serviceAccount = {
      create = true
      name   = local.alb_sa_name
      annotations = {
        "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
      }
    }
  })]
}
