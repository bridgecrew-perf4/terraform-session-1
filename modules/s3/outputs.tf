output "s3_id" {
  value = aws_s3_bucket.main.id
}

output "tags" {
  value = local.tags
}