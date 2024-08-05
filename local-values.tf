# Local values for reuse
locals {
  owners      = var.business_division
  environment = var.environment
  name        = "${var.business_division}-${var.environment}"

  # Common tags used across resources
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}
