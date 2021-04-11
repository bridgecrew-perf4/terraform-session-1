## Terraform reference to resources

In Terraform when you want reference to another resource/data source in a resource block/module, you don’t it put it inside of “-----”  marks as you would do when you hard code. By solving dependency issues we tell terraform in which order resources will be created/destroyed. The most common ```implicit``` dependency, it helps terraform to understand relationship between your resources. But sometimes dependencies between resources are not visible to terraform and in that case we use ```explicit``` dependency when you use an argument ```depends_on```, which is accepted by any resource/module. Since terraform will wait to create the dependent resource until after the specified resource is created, adding explicit dependencies can increase the length of time it takes for terraform to create your infrastructure. On ```description``` section of your configuration file the ```value``` of it always has to be inside  of the “” marks, that's  how terraform recommends. In implicit dependancy you specifically use the labels of the resource, and at the end you use (name, id, arn) depending on to which resource you want to reference to.  Every resource on AWS has unique id (logical id), that’s why we can reference to it. 
In the resource block when we specifically use plural ```values``` of the ```key``` we use [] brackets to list the resources id's or we also can give a ```name``` of that resource if we know.
Example of implicit dependency:
```
aws_security_group.web_sg.id
```
which came from this:
```
resource "aws_security_group" "web_sg" {
    .............
}
```
First label (resource type).Second label (Local name).Attribute (could be id, name, arn...) 

In terraform you also can to reference to ```named values```  sush as:

- Input variable
- Local values
- Resources (aws_security_group.web_sg.id)
- Child module outputs (module.rds_module.module_username)
- Data sources (data.aws_instance.id)
- file system and workspace info (terraform.workspace)
- block-local values 

The examples that we use earlier are called ```single bases```, when we use just single resource.

<p>
When we declare variables in var.tfvars file and and not in varaible.tf it's way easier to change our input variables, because we humans are tend to do some mistakes, which can cause an error. Instead of going to variable.tf file where could be a 100s of variables and we have to look for the variable that we want to change, in tfvars file is one line on code for every input variable.
</p>
<p>
When we define our dev.tf and qa.tf variables file they have to be inside of the tfvars directory, but if we want to keep them outside of tfvars directory we have to give dev.tfvars and qa.tfvars file extentions. When we want to pass our tfvars file on cli we have to give a path to that variables file, depending which environment we want to use. 
</p>

```
terraform apply -var-file=tfvars/dev.tf

```
Variables precedence is which variable will take a priority when is given:

1. Environmental variable
2. The terraform.tfvars file if present. 
3. The terraform.tfvars.json file if present
4. Any *auto.tfvars or *.auto.tfvars.json files processed in lexical order of their filenames.
5. Any -var and -var-file option on the command line in the order they are provided(this is including variables set by a terraform cloud workspace)

### Notes 

- When we change the size of the instance terraform doesn't delete the instance it will go stop the instance, resizes it and starts it again.

- In our example with ssh-key before we try to copy ssh-key to our AWS account we need to create first, otherwise terraform will complain that on a given file there's no such a file.

### Useful links

[Attributes Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

[Create Resource Dependencies](https://learn.hashicorp.com/tutorials/terraform/dependencies)

[Terraform variable types](https://www.terraform.io/docs/language/expressions/types.html)
