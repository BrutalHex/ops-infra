terraform {
  backend "s3" {
    bucket = "terraform-state-ops-infra"
    key    = "kubereks/01-state-infra.tfstate"
    region = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.47.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.1.0"
    }
  }
  required_version = ">=1.8.2"
}

provider "aws" {
  region = var.AWS_REGION
}
provider "cloudflare" {
  api_token = var.CLOUD_FLARE_API_TOKEN
}