data "aws_route53_zone" "my_zone" {
  name        = var.zone_name
} 

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.my_zone.zone_id
  name    = "www.${data.aws_route53_zone.my_zone.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.project_ec2.public_ip]
}