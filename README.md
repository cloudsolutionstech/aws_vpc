# Deploying a Secure 3-Tier AWS VPC Application on AWS with Terraform

## Overview

This project provides a step-by-step guide to design a 3-tier AWS Virtual Private Cloud (VPC) with NAT gateways using Terraform. By utilizing this configuration, you can automatically set up a secure and scalable 3-tier network (public, private, and database subnets) within AWS.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

- Create an [AWS account](https://aws.amazon.com/resources/create-account)
- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://aws.amazon.com/cli/) configured with your AWS credentials

## Files Description

Here is an overview and description of each file in the project:

### `versions.tf`

Specifies the required Terraform version and provider configurations.

```terraform
terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}


provider "aws" {
  region  = var.aws_region
  profile = "default"
}
```

- terraform block: Ensures compatibility with specified Terraform version and AWS provider.
- provider block: Configures the AWS provider with the specified region and profile.


### `outputs.tf`
Defines the outputs to retrieve information about the created resources.

```terraform
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "nat_public_ips" {
  description = "List of public Elastic IPs for NAT gateways"
  value       = module.vpc.nat_public_ips
}

output "azs" {
  description = "Availability zones used"
  value       = module.vpc.azs
}
```

- output blocks: Define various output parameters to retrieve VPC details like ID, subnets, and NAT gateway IPs.


### `local-values.tf`
Defines local values for reusability across the Terraform configuration.

```terraform
locals {
  owners      = var.business_divsion
  environment = var.environment
  name        = "${var.business_divsion}-${var.environment}"

  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}
```
locals block: Centralizes commonly reused values and tags.

### `terraform.tfvars`
Defines variable values specific to this Terraform configuration.

```terraform
aws_region       = "us-east-1"
environment      = "prod"
business_divsion = "Admin"
```

- aws_region, environment, business_divsion: Define specific values for AWS region, environment, and business division.

### `variables.tf`
Defines input variables that can be customized by users.

```terraform
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name to use as a prefix"
  type        = string
  default     = "dev"
}

variable "business_divsion" {
  description = "Business division within the organization"
  type        = string
  default     = "SAP"
}
```

- variable blocks: Define customizable input variables for AWS region, environment, and business division.


### `vpc-module.tf`
Configures the VPC module, specifying details for subnets, NAT gateways, and tags.

```terraform
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  name            = "${local.name}-${var.vpc_name}"
  cidr            = var.vpc_cidr_block
  azs             = var.vpc_availability_zones
  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets

  database_subnets                   = var.vpc_database_subnets
  create_database_subnet_group       = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table

  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags     = local.common_tags
  vpc_tags = local.common_tags

  public_subnet_tags = {
    Type = "Public Subnets"
  }
  private_subnet_tags = {
    Type = "Private Subnets"
  }
  database_subnet_tags = {
    Type = "Database Subnets"
  }
}
```

- module block: Configures the VPC using the terraform-aws-modules/vpc/aws module with specified details for subnets, NAT gateways, DNS settings, and tags.


### `vpc-variables.tf`
Defines variables specific to the VPC.

```terraform
variable "vpc_name" {
  description = "A name for the VPC"
  type        = string
  default     = "myvpc"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_availability_zones" {
  description = "List of availability zones for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for the VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_private_subnets" {
  description = "Private subnets for the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_database_subnets" {
  description = "Subnets for the database layer"
  type        = list(string)
  default     = ["10.0.151.0/24", "10.0.152.0/24"]
}

variable "vpc_create_database_subnet_group" {
  description = "Whether to create a DB subnet group"
  type        = bool
  default     = true
}

variable "vpc_create_database_subnet_route_table" {
  description = "Whether to create a route table for the DB subnets"
  type        = bool
  default     = true
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateways for outbound communication"
  type        = bool
  default     = true
}

variable "vpc_single_nat_gateway" {
  description = "Configure a single NAT gateway to reduce costs"
  type        = bool
  default     = true
}
```

variable blocks: Define variables for VPC configuration including name, CIDR block, availability zones, subnets, and NAT gateway settings.


### `vpc.auto.tfvars`
Automatically loaded variable file for VPC configuration.

```terraform
vpc_name                               = "cstvpc"
vpc_cidr_block                         = "10.0.0.0/16"
vpc_availability_zones                 = ["us-east-1a", "us-east-1b"]
vpc_public_subnets                     = ["10.0.101.0/24", "10.0.102.0/24"]
vpc_private_subnets                    = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_database_subnets                   = ["10.0.151.0/24", "10.0.152.0/24"]
vpc_create_database_subnet_group       = true
vpc_create_database_subnet_route_table = true
vpc_enable_nat_gateway                 = true
vpc_single_nat_gateway                 = true
```
vpc.auto.tfvars: Automatically loads values specific to VPC configuration.


## Usage
Clone this repository
```terraform
git clone git@github.com:cloudsolutionstech/aws_vpc.git
```
Change into the project directory
```terraform
cd aws_vpc
```
Initialize Terraform
```terraform
terraform init
```
Terraform Validate
```terraform
terraform validate
```
Terraform plan
```terraform
terraform plan
```
Apply the Terraform configuration
```terraform
terraform apply
```
- Confirm the execution by typing yes when prompted.
- Wait for Terraform to create the VPC and its associated resources.
- Or use auto approve
```terraform
terraform apply -auto-approve
```
- Observation:
1) Verify VPC
2) Verify Subnets
3) Verify IGW
4) Verify Public Route for Public Subnets
5) Verify no public route for private subnets
6) Verify NAT Gateway and Elastic IP for NAT Gateway
7) Verify NAT Gateway route for Private Subnets
8) Verify no public route or no NAT Gateway route to Database Subnets
9) Verify Tags

## Clean-Up
```terraform
Terraform Destroy
```
- Confirm the execution by typing yes when prompted.
- Use auto approve
```terraform
terraform destroy -auto-approve
```

# Delete Files
```terraform
rm -rf .terraform*
rm -rf terraform.tfstate*
```
