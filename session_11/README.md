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
    key    = "dev/s3.tfstate"
    region = "us-east-1"
  }
}
```

When you want to provision your resources in dev environment you run `terraform plan/apply -var-fils=tfvars/dev.tf` and your state file will be isolated under `dev` folder. That is how you will tell Terraform this state file belongs to `dev` environment and for other envoronment we modify backend and variables files, otherwise Terraform will overwrite state file.


The persistent data stored in the backend belongs to a workspace. Initially the backend has only one workspace, which called "default", and thus there is only one Terraform state associated with that configuration. When you run terraform workspace list/show you will get the next output,
```
[ec2-user@ip-172-31-82-91 session_11]$ terraform workspace show
default
[ec2-user@ip-172-31-82-91 session_11]$ terraform workspace list
* default
```

With Terraform workspaces we can create defferent workspaces and our state file will be isoloated by itself depending which workspace our resources are getting provisioned. For that we use 

the same resource for different environments and the name of our state file in backend.tf will not give us any errors, because it's is getting created in different workspaces also terraform workspace has an option to prefix our state files with env:/. But since we don’t want our resources with the same names, otherwise it will get confusing really fast.







We can do the same thing on terraform workspaces, and one more thing that I mentioned earlier we solve the name issue for our resource name with interpolations, but we can also use workspace name for it, in that case we don't depend on our tfvars/dev.tf or tfvars/qa.tf files.



each terraform configuration is defined in backend file, isolating your backend is great in terrform workspaces. in complany default workspace as a prod environment. it helps to solve backend  storing problem. 

Useful links:

[Workspaces](https://www.terraform.io/docs/cloud/workspaces/index.html)

[]()