#### Terraform backend

If you are a team who is using Terraform to manage your infrastructure, terraform recommends using remote backend file instead of storing your tfstate file locally. Storing your backend in AWS S3 bucket is one of the options of how you can do it. To do that we have to configure backend file first:
```
terraform {
  backend "s3" {
    bucket = "my-tf-bucket"
    key    = "dev/instance.tfstate"
    region = "us-east-1"
  }
}
```

 When we store our tfstate file remotely it allows us to be more flexible for working with  group of people(team), because all the team members can have access to it and it will make teamwork to go smooth. But before we configure storing our tfstate in S3 bucket, we have to make sure it exists. After that we run terraform init, which initializes storing our backend in given remote S3 bucket. Having a remote backend helps us to store in one S3 bucket different tfstate files for different environments. So if you want to provision the same infra, but for different environment we can use ```folder strucuture```. If we don't do it that, each time we run terraform apply, it will destroy existing infra and recreats the infra for diffenrent environment. So folder structure is comes very handy to isolating environments and provision our infra without having any effect on existing infrastructure.

 ### Element function

It is one of the terraform functions 