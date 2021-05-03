output "alb_dns" {
  value = aws_lb.web_lb.dns_name
}

output "rds_db_name" {
  value = data.terraform_remote_state.rds.outputs.rds_db_name
}

output "rds_db_username" {
  value = data.terraform_remote_state.rds.outputs.rds_db_username
}

output "rds_db_password" {
  value = data.terraform_remote_state.rds.outputs.rds_password
}

output "rds_db_endpoint" {
  value = data.terraform_remote_state.rds.outputs.rds_endpoint
}