output "public_ip" {
  value = aws_instance.web.public_ip
}
output "sec_grp_name" {
  value = aws_security_group.web_sg.name
}
output "private_ip" {
  value = aws_instance.web.private_ip
}
output "ec2_id" {
  value = aws_instance.web.id
}