# Terraform workspaces

When you work with Terraform it involves managing multiple infrastructure resources in  multiple environments, where each Terraform configuration has an associated backend that defines how operations are executed and where persistent data such as the Terraform state are stored.

When you work locally, Terraform manages each infrastructure with a persistent working directory, which contains a configuration, state data, and variables. Since Terraform CLI uses content from the directory it runs in, you can organize infrastructure resources into meaningful groups by keeping their configurations in separate directories.

The persistent data stored in the backend belongs to a workspace. Initially the backend has only one workspace, called "default", and thus there is only one Terraform state associated with that configuration.

each terraform configuration is defined in backend file, isolating your backend is great in terrform workspaces. in complany default workspace as a prod environment. it helps to solve backend  storing problem. 

Useful links:

[Workspaces](https://www.terraform.io/docs/cloud/workspaces/index.html)

[]()