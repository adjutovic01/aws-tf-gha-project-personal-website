resource "aws_s3_bucket" "static site" {
    bucket = var.bucket_name
}