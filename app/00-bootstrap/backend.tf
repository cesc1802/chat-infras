terraform {
  backend "s3" {
    region         = "ap-southeast-1"
    bucket         = "chat-app-tfstate"
    key            = "app/00-bootstrap/terraform.tfstate"
    dynamodb_table = "chat-app-tfstate-lock"
    profile        = "vmo"
    encrypt        = true
  }
}