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
