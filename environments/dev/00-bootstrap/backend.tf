terraform {
  backend "s3" {
    region         = "ap-southeast-1"
    bucket         = "dev-chat-app-tfstate"
    key            = "dev/00-bootstrap/terraform.tfstate"
    dynamodb_table = "dev-chat-app-tfstate-lock"
    profile        = "vmo"
    encrypt        = true
  }
}