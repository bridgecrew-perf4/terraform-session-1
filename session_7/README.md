# Terraform 2 tier application project

In this project we separated our `frontend` and `backend` in separate folders, because usually it gets complicated to manage both in one folder, we don't want any changes in backend to be effected by frontend.

### RDS (backend)

Lets talk about our `backend` directory, since we don't manage RDS database we don't even know where it gets provisioned [Relational Database Service (RDS) is managed by AWS](https://aws.amazon.com/rds/?did=ft_card&trk=ft_card). We just specify which engine we want it to run, version of the engine, instance_class and other attributes. 
Security group configured with 3306 is open to self and webserver security group, which gets fetched from the webserver security group module.
For tagging we used `local.common_tags` and merged it with the resource unique name.
Backend of our RDS database is stored remotely in s3 bucket `nazy-tf-bucket`, `session_7/backend.tfstate` file.

### Webserver (frontend)

Since we are working with Application, we have `Application Load Balancer` which provides the traffic to the subnets where our instances are sitting. As we know load balancer has to have a `Target group` first, for that we created target group with `Listeners rule HTTP` and Security group for load balancer with ports `80` ingress `0.0.0.0/0`, we didnt create egress rule, because as it was said above we don't manage our RDS. Our ALB is open to the world because we want our users to have access to it, that's why it's internet-facing.

We configured Auto Scaling Group as a part of frontend, but first we need create Launch Configuration, it was created with `amazon linux 2` image id. And it has user_data.sh script, which will run during bootstrapping.
```
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install epel -y
sudo amazon-linux-extras install php8.0 -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo yum install php-gd -y
sudo yum install mysql -y
sudo cp -r wordpress/* /var/www/html
sudo chown -R apache:apache /var/www/html
sudo systemctl restart httpd
```
Webserver security group was created with ports 80 to ALB, 3306 to RDS database and an egress rule "-1". And the last resource to complete ASG is `aws_autoscaling_attachment` which connecnts our ALB(through Target group) to ASG.
Same as RDS backend of webserver is stored remotely in the same s3 bucket `nazy-tf-bucket` but different file frontend.tfstate. `data_source` file has all the existing data fetching that we wanted to use in our configuration files.
Our `locals.tf` contains local tags and ingress rules for security group. It would be helpful if we had several ingress rules open like `443` as additional to `80` open to `0.0.0.0/0`, but in this case it's not that efficient.
In `outputs.tf` we have some outputs that we fetched from the backend folder, and dns name of ALB, so we don't have to go to the AWS console each time when we want to use it. The last file we is `variables.tf`, it has all the variables that we want to be adjusted depending on the environment, or different cases. The values for the variables are stored in `tfavars/dev.tf` file. 

### Tips and tricks in Terraform with outputs, locals, conditional expression and equality operators for boolean values.

- [Output values](https://www.terraform.io/docs/language/values/outputs.html)
- [Local Values](https://www.terraform.io/docs/language/values/locals.html)
- Combination of Equality Operators and Conditional Expressions for Boolean values.
    - [Conditional Expressions](https://www.terraform.io/docs/language/expressions/conditionals.html)
    - [Equality Operators](https://www.terraform.io/docs/language/expressions/operators.html#equality-operators)
    - [Boolean or bool](https://www.terraform.io/docs/language/expressions/types.html#bool)

### Outputs in Terraform

##### First example of output usage.

In order to get the outputs in frontend from the backend folder such as database_name, database_password or database_username we need to do the next steps:

1. Create ```outputs.tf``` with those values in ```backend folder```.

2. In ```frontend folder``` create a ```data source``` with the path to s3 bucket with backend.tfstate file.

3. Then create ```outputs.tf``` in ```frontend``` folder, on the value for the outputs we will refer to ```data "terraform_remote_state" "rds" {...}```, and terraform will fetch the data that we want to retrive from there. It is more clear when it shown below;

Backend ```outputs.tf```,
```
output "rds_password" {
  value = random_password.password.result
}

output "rds_db_name" {
  value = aws_db_instance.rds_db.name
}

output "rds_db_username" {
  value = aws_db_instance.rds_db.username
}
```
```data_source.tf``` in frontend folder,
```
.........
data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket = "nazy-tf-bucket"
    key = "session_7/backend.tfstate"
    region = "us-east-1"
  }
}
```
Frontend outputs.tf,
```
output "rds_db_name" {
  value = data.terraform_remote_state.rds.outputs.rds_db_name
}

output "rds_db_username" {
  value = data.terraform_remote_state.rds.outputs.rds_db_username
}

output "rds_db_password" {
  value = data.terraform_remote_state.rds.outputs.rds_password
}
```
##### The second example of outputs usage. 

Another example of outputs usage is when we want fetch the database security group id for ```source_security_group_id``` in webserver security group ingress (3306)rule. For that we again refer to remote backend.tfstate file (```data "terraform_remote_state" "rds" {...}```) and terraform will get that id and creates the rule as it shown here,

```web_sg``` security group rule mysql,
```
resource "aws_security_group_rule" "mysql_to_db" {
  type              = "ingress"
  .................
  source_security_group_id = data.terraform_remote_state.rds.outputs.rds_sg_id 
  security_group_id = aws_security_group.web_sg.id
}
```
### Locals in Terraform

When we want to avoid repeationg the same values or expressions multiple times in configuration file. The most common usage of locals are for tag values, as we know sometimes our tags can get really long, and to make our code more clean we create common_tags attach them to our resources. 

locals.tf file, 
```
locals {
  common_tags = {
    environment = var.env
    project     = "${var.env}-wordpress"
    team        = "DevOps"
    owner       = "Nazy"
    timestamp = timestamp()
  }
}
```
rds.tf file,
```
  tags = local.common_tags
```
or if we want to merge the unique name of our resource we can combine common tags with the name tag as it show in this example,
```
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_rds_db"
    }
  )
```
### Combination of Equality Operators and Conditional Expressions for Boolean values.

When it comes to the boolean values in Terraform we can either use simple variables or make our code more efficient and combine `Equality Operators` and `Conditional Expressions`. For example if we want certain resource to be available/not available for public we can just say, make publicly available/not available and give a value `true` or `false`. But in some cases we want that resource to be available for a group (team) of people and not available others, in that case `Equality Operators` and `Conditional Expressions` comes very handy. 
rds.tf file,
```
resource "aws_db_instance" "rds_db" {
  ...............
  publicly_accessible       = true # hard coded
}
```
or,
```
variables.tf "is_publicly_accessible"{
  type    = bool
  default = true
}

resource "aws_db_instance" "rds_db" {
  ...............
  publicly_accessible       = var.is_publicly_accessible # used variables
}
```
or,
```
variable "env" {
  type    = string
  default = "dev"
}

resource "aws_db_instance" "rds_db" {
...............
publicly_accessible  =  var.env == "dev" ? true : false  # true bs our env is "dev"
}
```
Which means if it's `dev` environment make publicly accessible (because we want dev team to have access to the database to manage it), if not don't make publicly accessible. 

### Modules in Terraform

But for the RDS security group we also need to create another rule 3306 going to web_sg 