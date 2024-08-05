# Input variable for AWS region
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

# Input variable for environment
variable "environment" {
  description = "Environment name to use as a prefix"
  type        = string
  default     = "prod"
}

# Input variable for business division
variable "business_division" {
  description = "Business division within the organization"
  type        = string
  default     = "Admin"
}
cloud@cloudsolutions MINGW64 ~/Desktop/aws-vpc (main)
$ cat vpc-variables.tf
# VPC Name variable
variable "vpc_name" {
  description = "A name for the VPC"
  type        = string
  default     = "cstvpc"
}

# VPC CIDR block variable
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Availability zones for the VPC
variable "vpc_availability_zones" {
  description = "List of availability zones for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Public subnets for the VPC
variable "vpc_public_subnets" {
  description = "Public subnets for the VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

# Private subnets for the VPC
variable "vpc_private_subnets" {
  description = "Private subnets for the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Database subnets configuration
variable "vpc_database_subnets" {
  description = "Subnets for the database layer"
  type        = list(string)
  default     = ["10.0.151.0/24", "10.0.152.0/24"]
}

# Variable to enable/disable database subnet group creation
variable "vpc_create_database_subnet_group" {
  description = "Whether to create a DB subnet group"
  type        = bool
  default     = true
}

# Variable to enable/disable database subnet route table creation
variable "vpc_create_database_subnet_route_table" {
  description = "Whether to create a route table for the DB subnets"
  type        = bool
  default     = true
}

# Variable to enable NAT gateways
variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateways for outbound communication"
  type        = bool
  default     = true
}

# Variable for single NAT gateway configuration
variable "vpc_single_nat_gateway" {
  description = "Configure a single NAT gateway to reduce costs"
  type        = bool
  default     = true
}

