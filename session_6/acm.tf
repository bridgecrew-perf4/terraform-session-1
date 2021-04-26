# Find a certificate that is issued
data "aws_acm_certificate" "my_certificate" {
  domain   = "nazydaisy.com"
  statuses = ["ISSUED"]
}

# # Find a certificate issued by (not imported into) ACM
# data "aws_acm_certificate" "my_certificate" {
#   domain      = "www.nazydaizy.com"
#   types       = ["AMAZON_ISSUED"]
#   most_recent = false #true
# }

resource "aws_lb_listener_certificate" "acm_attachment" {
  listener_arn    = aws_lb_listener.https_listener.arn
  certificate_arn = data.aws_acm_certificate.my_certificate.arn
}

data "aws_route53_zone" "my_zone" {
  name = var.zone_name
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.my_zone.zone_id
  name    = "www.${data.aws_route53_zone.my_zone.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.wordpress_web.public_ip]
}