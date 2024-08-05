terraform {
  required_version = ">= 1.6" # Specify the minimum required Terraform version.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0" # Specify the minimum AWS provider version.
    }
  }
}

# AWS provider configuration
provider "aws" {
  region  = var.aws_region # Define the AWS region to deploy resources.
  profile = "default"      # Use the default AWS CLI profile.
}

