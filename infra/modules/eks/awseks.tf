
resource "aws_eks_cluster" "eks" {
  name     = var.APP_NAME
  role_arn = aws_iam_role.eks_direct_iam.arn
  version  = "1.32"
  vpc_config {
    subnet_ids = [for item in aws_subnet.public_subnet : item.id]
  }
  access_config {
    authentication_mode = "API"
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_policy,
    aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController,
  ]
  tags = merge(local.common_tags,
    {
      Name = "${var.APP_NAME}"
    }
  )
}

locals {
  combined_list = concat(var.EXTRA_EKS_ADMIN_ACCESS_PRINCIPAL_ARNS, [var.GITHUB_OIDC_ROLE_ARN])
}

resource "aws_eks_access_entry" "eks-access" {
  for_each      = toset(local.combined_list)
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = each.value
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks-admin-access" {
  for_each      = aws_eks_access_entry.eks-access
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = each.value.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = "eks_auth"
  depends_on = [
    aws_eks_cluster.eks
  ]
}



resource "aws_iam_role" "eks_direct_iam" {
  name               = "eks_direct_iam"
  assume_role_policy = data.aws_iam_policy_document.eks_direct_iam_policy.json
  tags = merge(local.common_tags, {
    Name = "${var.APP_NAME}_eks_direct_iam"
  })
}

data "aws_iam_policy_document" "eks_direct_iam_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_direct_iam.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_direct_iam.name
}
