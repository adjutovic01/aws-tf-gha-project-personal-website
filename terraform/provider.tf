provider "aws" {
  region = "us-east-1" # to use ACM with CloudFront, the certificate must be in us-east-1"
}

terraform {
  backend "s3" {
    bucket = "tf-resources-gha-djuta"
    key    = "github-actions/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "tf-resources-gha-lock"
  }
}