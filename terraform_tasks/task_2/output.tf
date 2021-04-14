output "wordpress_public_ip" {
  value = aws_instance.wordpress_web.public_ip
}
output "wp_sg_name" {
  value = aws_security_group.wordpress_sg.name
}
output "public_dns" {
  value = aws_instance.wordpress_web.public_dns
}