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

  s3_bucket_name      = "chat-app-tfstate"
  dynamodb_table_name = "chat-app-tfstate-lock"
  force_destroy       = true

  tags = merge(
    { Name : "chat-app-terraform" },
    local.common_tags
  )
}