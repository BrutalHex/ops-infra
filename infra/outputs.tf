output "region" {
  description = "AWS region where the resources are deployed"
  value       = var.AWS_REGION
}

output "endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.app-eks.endpoint
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider for the EKS cluster"
  value       = module.app-eks.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "URL of the OIDC provider for the EKS cluster"
  value       = module.app-eks.oidc_provider_url
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.app-eks.cluster_name
}

output "cluster_id" {
  description = "Kubernetes Cluster ID"
  value       = module.app-eks.cluster_id
}

output "cluster_autoscaler_role" {
  description = "Kubernetes Cluster role for auto scaler"
  value       = module.app-eks.cluster_autoscaler_role
}

output "eks_certificate_authority_data" {
  description = "Kubernetes Cluster certificate authority data"
  value       = module.app-eks.eks_certificate_authority_data
}

output "csi_driver_service_account_name" {
  description = "Service account name for the CSI driver"
  value       = module.app-eks.csi_driver_service_account_name
}

output "aws_iam_role_csi_driver_arn" {
  description = "ARN of the IAM role for the CSI driver"
  value       = module.app-eks.aws_iam_role_csi_driver_arn
}

output "route53_service_account_name_external_dns" {
  description = "Service account name for external DNS in Route 53"
  value       = module.app-eks.route53_service_account_name_external_dns
}

output "service_account_name_cert_manager" {
  description = "Service account name for the cert-manager"
  value       = module.app-eks.service_account_name_cert_manager
}

output "service_account_name_cert_manager_namespace" {
  description = "Namespace for the cert-manager service account"
  value       = module.app-eks.service_account_name_cert_manager_namespace
}

output "aws_iam_role_route53_arn" {
  description = "ARN of the IAM role for Route 53"
  value       = module.app-eks.aws_iam_role_route53_arn
}

output "route53_id" {
  description = "ID of the Route 53 hosted zone"
  value       = module.app-eks.route53_id
}

output "aws_iam_role_load_balancer_arn" {
  description = "ARN of the IAM role for the load balancer"
  value       = module.app-eks.aws_iam_role_load_balancer_arn
}

output "load_balancer_service_account" {
  description = "Service account for the load balancer"
  value       = module.app-eks.load_balancer_service_account
}

output "cluster_information_secret" {
  description = "Name of the AWS Secrets Manager secret"
  value       = local.information_secret_name
  sensitive = false
}