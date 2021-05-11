output "rds_password" {
  value = random_password.password.result
}

output "rds_db_name" {
  value = aws_db_instance.rds_db.name
}

output "rds_db_username" {
  value = aws_db_instance.rds_db.username
}

output "rds_endpoint" {
  value = aws_db_instance.rds_db.address
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}