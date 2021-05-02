output "rds_password" {
  value = random_password.password.result
}