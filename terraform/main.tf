resource "aws_s3_bucket" "static_site" {
    bucket = var.bucket_name
}

# resource "aws_s3_bucket_website_configuration" "static_website_config" {
#     bucket = aws_s3_bucket.static_site.id

#     index_document {
#         suffix = "index.html"
#     }
# }

resource "aws_s3_bucket_public_access_block" "static_site_access" {
    bucket = aws_s3_bucket.static_site.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}
#resource "aws_s3_bucket_policy" "static_site_policy" {
#   bucket = aws_s3_bucket.static_site.id
#   policy = jsonencode({
#       Version = "2012-10-17"
#       Statement = [
#            {
#                Effect = "Allow"
#                Principal = "*"
#                Action = "s3:GetObject"
#                Resource = "${aws_s3_bucket.static_site.arn}/*"
#           }
#       ]
#   })
#   depends_on = [aws_s3_bucket_public_access_block.static_site_access]
#}

data "aws_route53_zone" "domain_zone" {
    name    = "djuta.org"
}

resource "aws_acm_certificate" "adjutovic_cert" {
    domain_name       = "djuta.org"
    validation_method = "DNS"

    subject_alternative_names = [
        "www.djuta.org"
    ]
    tags = {
        Name = "djuta.org SSL Certificate"
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_route53_record" "adjutovic_cert_validation" {
    for_each = {
        for dvo in aws_acm_certificate.adjutovic_cert.domain_validation_options : dvo.domain_name => {
            name   = dvo.resource_record_name
            type   = dvo.resource_record_type
            record = dvo.resource_record_value
        }
    }

    zone_id = data.aws_route53_record.domain_zone.zone_id
    name    = each.value.name
    type    = each.value.type
    records = [each.value.record]
    ttl     = 60
}
resource "aws_acm_certificate_validation" "adjutovic_cert_validation" {
    certificate_arn         = aws_acm_certificate.adjutovic_cert.arn
    validation_record_fqdns = [for record in aws_route53_record.adjutovic_cert_validation : record.fqdn]
}

