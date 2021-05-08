data "terraform_remote_state" "s3" {
    backend = "s3"
    config = {
        bucket = "nazy-tf-bucket"
        key = "review/terraform.tfstate"
        region = "us-east-1"
    }
}