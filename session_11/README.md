# Terraform workspaces

When you work with Terraform it involves managing multiple infrastructure resources in  multiple environments, where each Terraform configuration has an associated backend that defines how operations are executed and where persistent data such as the Terraform state are stored.

When you work locally, Terraform manages each of your infrastructure within working directory, which contains a configuration, state data, and variables. Since Terraform CLI uses content from the directory it runs in, you can organize infrastructure resources into meaningful groups by keeping their configurations in separate directories. For environment isolation we use variables files "dev" or "qa", and our backend file has to be hardcoded (we can't use variables in backend.tf).

tfvars/dev.tf
```
variable "env" {
  type    = string
  default = "dev"
}
```
backend.tf
```
terraform {
  backend "s3" {
    bucket = "nazy-tf-bucket"
    key    = "dev/sqs.tfstate"
    region = "us-east-1"
  }
}
```

When you want to provision your resources in dev environment you run `terraform plan/apply -var-fils=tfvars/dev.tf` and your state file will be isolated under `dev` folder. That is how you will tell Terraform this state file belongs to `dev` environment and for other envoronment we modify backend and variables files, otherwise Terraform will overwrite state file.

Terraform starts with a single workspace named "default". This workspace is special both because it is the default and also because it cannot ever be deleted. If you've never explicitly used workspaces, then you've only ever worked on the "default" workspace.

With Terraform workspaces we can create different workspaces for environmetn isolation and our state file will be isolated by itself depending which workspace our resources are getting provisioned. The persistent data stored in the backend belongs to a workspace. Initially the backend has only one workspace, which called "default", and thus there is only one Terraform state associated with that configuration. When you run terraform workspace list/show you will get the next output,

```
[ec2-user@ip-172-31-82-91 session_11]$ terraform workspace show
default
[ec2-user@ip-172-31-82-91 session_11]$ terraform workspace list
* default
```

On the names of our resources we use ${terraform.workspaces} interpolation sequence,

main.tf,
```
resource "aws_sqs_queue" "first_sqs" {
  name = "${terraform.workspace}-example-queque"
}
```

Since we are working on `default workspace` the output will come out like this,
```
# aws_sqs_queue.first_sqs will be created
+ resource "aws_sqs_queue" "first_sqs" {
    + arn                               = (known after apply)
    + content_based_deduplication       = false
    + delay_seconds                     = 0
    + fifo_queue                        = false
    + id                                = (known after apply)
    + kms_data_key_reuse_period_seconds = (known after apply)
    + max_message_size                  = 262144
    + message_retention_seconds         = 345600
    + name                              = "default-example-queque"
    + name_prefix                       = (known after apply)
    + policy                            = (known after apply)
    + receive_wait_time_seconds         = 0
    + tags_all                          = (known after apply)
    + visibility_timeout_seconds        = 30
  }
```

In the backend.tf file we use `workspace_key_prefix` otherwise our state file will be stored under  `env:/` folder and it can get confusing, but since we want to have our state files in order under we use prefix and all our state files will be stord under one folder.

backend.tf, 
```
terraform {
  backend "s3" {
    bucket               = "nazy-tf-bucket"
    key                  = "main.tfstate"
    region               = "us-east-1"
    workspace_key_prefix = "session_11"
  }
}
```

Most of the time companies treat `default` workspace as a `production` workspace, which describes the intended state of production infrastructure. When a feature branch is created to develop a change, the developer of that feature might create a corresponding workspace and deploy into it a temporary "copy" of the main infrastructure so that changes can be tested without affecting the production infrastructure. Once the change is merged and deployed to the default workspace, the test infrastructure can be destroyed and the temporary workspace deleted.

## Useful links:

[Workspaces](https://www.terraform.io/docs/language/state/workspaces.html#when-to-use-multiple-workspaces)