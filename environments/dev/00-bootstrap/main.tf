provider "aws" {
  region = var.region
  profile = var.profile
}

locals {
  common_tags = {
    Project     = "Chat App"
    ManagedBy   = "Terraform"
  }
}

module "terraform_state_backend" {
  source  = "cloudposse/tfstate-backend/aws"
  version = "1.4.0"

  namespace   = "chat-app"
  stage       = "bootstrap"
  name        = "terraform"

  s3_bucket_name      = "${var.environment}-chat-app-tfstate"
  dynamodb_table_name = "${var.environment}-chat-app-tfstate-lock"
  force_destroy       = true

  tags = merge(
    { Name : "${var.environment}-chat-app-terraform" },
    local.common_tags
  )
}