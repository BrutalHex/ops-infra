terraform {
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
}