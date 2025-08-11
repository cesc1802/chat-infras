provider "aws" {
  region  = var.region
  profile = var.profile
}

locals {
  common_tags = {
    Project   = "Chat App"
    ManagedBy = "Terraform"
  }
}

module "chat_app_ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.4.0"

  repository_name          = "chat-app"
  create_repository        = true
  repository_type          = "private"
  create_repository_policy = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 production versions",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v", "prod-"],
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2,
        description  = "Keep last 10 commit-tagged images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  tags = merge(
    { Name : "chat-app-ecr" },
    local.common_tags
  )
}
