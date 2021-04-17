output "wordpress_public_ip" {
  value = aws_instance.wordpress_web.public_ip
}
output "wordpress_private_ip" {
  value = aws_instance.wordpress_web.private_ip
}
output "wordpressdb_public_ip" {
  value = aws_instance.wordpress_db.public_ip
}
output "wp_sg_name" {
  value = aws_security_group.wordpress_sg.name
}
output "public_dns" {
  value = aws_instance.wordpress_web.public_dns
}
output "dns_name" {
  value = aws_route53_record.record.name
}