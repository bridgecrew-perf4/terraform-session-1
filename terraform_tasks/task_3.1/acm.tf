# Fetch a certificate that is issued
data "aws_acm_certificate" "my_certificate" {
  domain   = "nazydaisy.com"
  statuses = ["ISSUED"]
}