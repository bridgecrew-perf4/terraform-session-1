output "lb_dns_name" {
  value = aws_lb.web_lb.dns_name
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "tag" {
  value = local.common_tags
}