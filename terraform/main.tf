resource "aws-s3-bucket" "static site" {
    bucket = var.bucket_name
}