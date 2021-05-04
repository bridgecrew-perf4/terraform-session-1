output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
output "public_subnets" {
  value = aws_subnet.public_subnet[*].id
}
output "private_subnets" {
  value = aws_subnet.private_subnet[*].id
}
output "lb_dns_name" {
  value = aws_lb.web_lb.dns_name
}
output "tag" {
  value = local.common_tags
}