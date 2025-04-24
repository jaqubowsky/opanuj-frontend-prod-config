terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.40.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}


module "features" {
  source = "./modules/features"

  features_bucket_name = "opanuj-frontend-prod-config-features"
}
