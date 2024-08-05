# Outputs the ID of the created VPC
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

# Outputs the CIDR block of the VPC
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# Outputs the IDs of private subnets
output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

# Outputs the IDs of public subnets
output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

# Outputs the public IPs of NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs for NAT gateways"
  value       = module.vpc.nat_public_ips
}

# Outputs the availability zones
output "azs" {
  description = "Availability zones used"
  value       = module.vpc.azs
}

