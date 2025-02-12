variable "APP_ENVIRONMENT" {
  description = "the name of the environment , eg: dev,test,..."
  type        = string
  default     = "dev"
}
variable "AWS_REGION" {
  description = "the aws region that the infrastructure will be deployed"
  type        = string
}

variable "VPC_CIDRBLOCK" {
  description = "the cidr block of vpc"
  type        = string
  default     = "172.32.0.0/16"
}

variable "APP_NAME" {
  description = "the name of the application group"
  type        = string
  default     = "myapp"
}

variable "GITHUB_OIDC_ROLE_ARN" {
  description = "The role ARN for the OIDC role"
  type        = string
}

variable "EXTRA_EKS_ADMIN_ACCESS_PRINCIPAL_ARNS" {
  description = "Extra role principal ARNs to add to the EKS cluster"
  type        = list(string)
  default     = []
}

variable "DOMAIN" {
  description = "the domain for managing DNS records, ex: example.com"
  type        = string
}
variable "SUB_DOMAIN" {
  description = "the sub domain to use as parent domain of applications, ex: app"
  type        = string
}
variable "CLOUD_FLARE_API_TOKEN" {
  description = "the cloudflare api token"
  type        = string
  sensitive   = true
}
variable "CLOUDFLARE_ZONE_ID" {
  description = "The zone id of cloudflare"
  type        = string
}