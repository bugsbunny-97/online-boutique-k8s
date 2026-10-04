locals {
  alb_sa_namespace = "kube-system"
  alb_sa_name      = "aws-load-balancer-controller"
}

# WHAT the controller may do: AWS's published policy for this controller version.
resource "aws_iam_policy" "alb_controller" {
  name        = "${local.cluster_name}-alb-controller"
  description = "Permissions for the AWS Load Balancer Controller"
  policy      = file("${path.module}/iam_policy_alb_controller.json")
}

# WHO may assume the role: only this service account, via the cluster's OIDC provider.
data "aws_iam_policy_document" "alb_controller_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values   = ["system:serviceaccount:${local.alb_sa_namespace}:${local.alb_sa_name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "alb_controller" {
  name               = "${local.cluster_name}-alb-controller"
  assume_role_policy = data.aws_iam_policy_document.alb_controller_trust.json
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}
