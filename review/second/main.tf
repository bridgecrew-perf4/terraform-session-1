resource "aws_s3_bucket_object" "object" {
  bucket = data.terraform_remote_state.s3.outputs.s3_id # output from the first folders remote state file
  key    = "test-key.txt" # the name of the object once it is in the bucket
  source = "test.txt" # path to file that will be read and uploaded as a raw bytes for the content
} 