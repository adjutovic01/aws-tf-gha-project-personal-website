provider "aws" {
  
}

terraform {
  backend "s3" {
    bucket = "tf-resources-gha-djuta"
    key    = "github-actions/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "tf-resources-gha-djuta-lock"
  }
}