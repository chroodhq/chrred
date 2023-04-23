resource "aws_acm_certificate" "public_domain" {
  provider = aws.virginia

  domain_name       = local.domain
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "public_domain" {
  provider = aws.virginia

  certificate_arn         = aws_acm_certificate.public_domain.arn
  validation_record_fqdns = [for record in aws_route53_record.public_domain : record.fqdn]
}
