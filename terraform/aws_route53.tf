data "aws_route53_zone" "domain" {
  name         = var.root_domain
  private_zone = false
}

resource "aws_route53_record" "public_domain" {
  for_each = {
    for dvo in aws_acm_certificate.public_domain.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60
  zone_id         = data.aws_route53_zone.domain.zone_id
}

resource "aws_route53_record" "root_domain_mapping" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = aws_api_gateway_domain_name.stack_root_domain.domain_name
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.stack_root_domain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.stack_root_domain.cloudfront_zone_id
    evaluate_target_health = false
  }
}
