output "wordpress_public_ip" {
  value = aws_instance.wordpress_web.public_ip
}
output "wordpress_private_ip" {
  value = aws_instance.wordpress_web.private_ip
}
output "wordpressdb_public_ip" {
  value = aws_instance.wordpress_db.public_ip
}
output "wordpressdb_private_ip" {
  value = aws_instance.wordpress_db.private_ip
}
output "wp_sg_name" {
  value = aws_security_group.wordpress_sg.name
}
output "wpdb_sg_name" {
  value = aws_security_group.wordpress_db_sg.name
}
output "dns_name" {
  value = aws_route53_record.record.name
}