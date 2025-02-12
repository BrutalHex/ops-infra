# "app-eks" module initializes the infrastructure
module "app-eks" {
  source                                = "./modules/eks"
  APP_ENVIRONMENT                       = var.APP_ENVIRONMENT
  AWS_REGION                            = var.AWS_REGION
  VPC_CIDRBLOCK                         = var.VPC_CIDRBLOCK
  APP_NAME                              = var.APP_NAME
  DOMAIN                                = var.DOMAIN
  SUB_DOMAIN                            = var.SUB_DOMAIN
  GITHUB_OIDC_ROLE_ARN                  = var.GITHUB_OIDC_ROLE_ARN
  EXTRA_EKS_ADMIN_ACCESS_PRINCIPAL_ARNS = var.EXTRA_EKS_ADMIN_ACCESS_PRINCIPAL_ARNS
  CLOUDFLARE_ZONE_ID  = var.CLOUDFLARE_ZONE_ID
}

resource "random_string" "secret_suffix" {
  length  = 8
  special = false
}

locals {
  information_secret_name="${var.APP_NAME}_${var.APP_ENVIRONMENT}-secrets-${random_string.secret_suffix.result}"
}

resource "aws_secretsmanager_secret" "app-eks" {
  name = local.information_secret_name
  tags = {
    env = "${var.APP_NAME}_${var.APP_ENVIRONMENT}_eks"
  }
}

locals {
  cluster_outputs = {
    region                                      = var.AWS_REGION
    endpoint                                    = module.app-eks.endpoint
    oidc_provider_arn                           = module.app-eks.oidc_provider_arn
    oidc_provider_url                           = module.app-eks.oidc_provider_url
    cluster_name                                = module.app-eks.cluster_name
    cluster_id                                  = module.app-eks.cluster_id
    cluster_autoscaler_role                     = module.app-eks.cluster_autoscaler_role
    eks_certificate_authority_data              = module.app-eks.eks_certificate_authority_data
    csi_driver_service_account_name             = module.app-eks.csi_driver_service_account_name
    aws_iam_role_csi_driver_arn                 = module.app-eks.aws_iam_role_csi_driver_arn
    route53_service_account_name_external_dns   = module.app-eks.route53_service_account_name_external_dns
    service_account_name_cert_manager           = module.app-eks.service_account_name_cert_manager
    service_account_name_cert_manager_namespace = module.app-eks.service_account_name_cert_manager_namespace
    aws_iam_role_route53_arn                    = module.app-eks.aws_iam_role_route53_arn
    route53_id                                  = module.app-eks.route53_id
    domain                                      = module.app-eks.route53_domain
    aws_iam_role_load_balancer_arn              = module.app-eks.aws_iam_role_load_balancer_arn
    load_balancer_service_account               = module.app-eks.load_balancer_service_account
    vpc_id                                      = module.app-eks.vpc_id
  }
}

resource "aws_secretsmanager_secret_version" "app-eks" {
  secret_id     = aws_secretsmanager_secret.app-eks.id
  secret_string = jsonencode(local.cluster_outputs)
}
