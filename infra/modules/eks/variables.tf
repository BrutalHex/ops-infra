variable "APP_ENVIRONMENT" {
  description = "The name of the environment, e.g., dev, test, etc."
  default     = "dev"
}

variable "AWS_REGION" {
  description = "The AWS region where the infrastructure will be deployed"
}

variable "VPC_CIDRBLOCK" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "APP_NAME" {
  description = "The name of the application group"
  type        = string
}

variable "AZ_NUMBER" {
  description = "The availability zones"
  default = {
    a = 1,
    b = 2
  }
}

variable "DOMAIN" {
  description = "the domain for managing DNS records, ex: example.com"
  type        = string
}
variable "SUB_DOMAIN" {
  description = "the sub domain to use as parent domain of applications, ex: app"
  type        = string
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
variable "CLOUDFLARE_ZONE_ID" {
  description = "The zone id of cloudflare"
  type        = string
}