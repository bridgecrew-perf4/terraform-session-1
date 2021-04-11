### Terraform reference to resources

In Terraform when you want reference to another resource/data source in your resource block, you don’t it put it inside of “-----”  marks, you use implicit or explicit way to do that. The most common source dependencies is an ```implicit``` dependency, it helps terraform to understand relationship between your resources. But sometimes dependencies between resources are not visible to terraform and in that case we use ```explicit``` dependency you use  an argument ```depends_on``` which accepted by any resource or module. Since terraform will wait to create the dependent resource until after the specified resource is created, adding explicit dependencies can increase the length of time it takes for terraform to create your infrastructure. On description ```key``` the ```value``` always hasto be inside  of the “” marks, that's  how terraform recommended. In implicit dependancy you take you specifically use the labels of the resource, and at the end you use (name, id, arn check the official documentation) depending of the resource what you want to reference.  Every resource has unique id (logical id), that’s why we can reference to. 
When we specify plural values of the key in the block we use [] to list of resources id's that we want to refer.

First label (resource type).Second label (Local name).Attribute (could be id, name, arn) 

Name values
Input variable

Single bases are when we use just single resource and Modules
declare variables in var.tfvars file where you can change your input variables there. we dont have to even touch the variables.tf file.
different configurations for the same modules.

When we change the size of the instance terraform doesn't delete the instance it will go stop the instance , resizes it and starts again. 

When you define your dev.tf and qa.tf variables file they have to be inside of the tfvars directory because they are inside of the tfvars directory. If you want to keep them outside of tfvars directory you have to give dev.tfvars and qa.tfvars file extentions on the name of the files.

When you pass your tfvars file on cli you have to give a path to that variables file which environment we want to use. 
```
-var-file=tfvars/dev.tf

```
Variables precedence is which variable will take a priority when is given:

1. Environmental variable
2. The terraform.tfvars file if present. 
3. The terraform.tfvars.json file if present
4. Any *auto.tfvars or *.auto.tfvars.json files processed in lexical order of their filenames.
5. Any -var and -var-file option on the command line in the order they are provided(this is including variables set by a terraform cloud workspace)



## Useful links

[Attributes Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

[Create Resource Dependencies](https://learn.hashicorp.com/tutorials/terraform/dependencies)
