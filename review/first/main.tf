resource "aws_s3_bucket" "main" {
  bucket = "${var.env}-tf-nazy-bucket"
  acl    = "private"

  tags = local.tags
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id
  ignore_public_acls = true
  restrict_public_buckets = true
  block_public_acls   = true
  block_public_policy = true
}