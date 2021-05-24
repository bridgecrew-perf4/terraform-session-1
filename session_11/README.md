# Terraform workspaces

When you work with Terraform it involves managing multiple infrastructure resources in  multiple environments, where each Terraform configuration has an associated backend that defines how operations are executed and where persistent data such as the Terraform state are stored.

The persistent data stored in the backend belongs to a workspace. Initially the backend has only one workspace, called "default", and thus there is only one Terraform state associated with that configuration.

When you work locally, Terraform manages each your infrastructure within working directory, which contains a configuration, state data, and variables. Since Terraform CLI uses content from the directory it runs in, you can organize infrastructure resources into meaningful groups by keeping their configurations in separate directories.

With Terraform workspaces we can create defferent workspaces and our state file will be isoloated byitself depending which workspace our resources are getting provisioned. the same resource for different environments and the name of our state file in backend.tf will not give us any errors, because it's is getting created in different workspaces also terraform workspace has an option to prefix our state files with env:/. But since we don’t want our resources with the same names, otherwise it will get confusing really fast.

We can do the same thing on terraform workspaces, and one more thing that I mentioned earlier we solve the name issue for our resource name with interpolations, but we can also use workspace name for it, in that case we don't depend on our tfvars/dev.tf or tfvars/qa.tf files.



each terraform configuration is defined in backend file, isolating your backend is great in terrform workspaces. in complany default workspace as a prod environment. it helps to solve backend  storing problem. 

Useful links:

[Workspaces](https://www.terraform.io/docs/cloud/workspaces/index.html)

[]()