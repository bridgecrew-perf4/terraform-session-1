# Fetch a certificate that is issued
data "aws_acm_certificate" "my_certificate" {
  domain   = "nazydaisy.com"
  statuses = ["ISSUED"]
}

# Route 53 record
resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.my_zone.zone_id
  name    = "www.${data.aws_route53_zone.my_zone.name}"
  type    = "A"

  alias {
    name                   = aws_lb.web_lb.dns_name
    zone_id                = aws_lb.web_lb.zone_id
    evaluate_target_health = true
  }
}