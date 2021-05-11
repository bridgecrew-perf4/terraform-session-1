# Terraform 2 tier application WordPress Project

In this project we separated our `frontend` and `backend` in separate folders, because usually it gets complicated to manage both in one folder, we don't want any changes made in backend to be effected by frontend.

### RDS (backend)

Lets talk about our `backend` directory, since we don't manage RDS database we don't even know where it gets provisioned [Relational Database Service (RDS) is managed by AWS](https://aws.amazon.com/rds/?did=ft_card&trk=ft_card). We just specify which engine we want it to run, version of the engine, instance_class and other attributes.

- RDS Security group configured with 3306 is open to self and referenced to webserver security group. We didn't create egress rule for RDS security group, because we don't manage our RDS and database doesn't initiate connections, so nothing outbound should need to be allowed.
```
resource "aws_security_group" "rds_sg"{
  .....................
}
resource "aws_security_group_rule" "mysql_to_web_sg" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_sg.id
  security_group_id        = aws_security_group.rds_sg.id
}
```

- Webserver security group was created with ports 80 to ALB, 3306 to RDS database and an egress rule "-1" open to the world. We are creating webserver security group in backend folder, because we will provision RDS (backend) first and in webserver we fetch some outputs from the remote backend of the RDS state file.
```
resource "aws_security_group" "web_sg" {
  .............................
}
resource "aws_security_group_rule" "mysql_to_rds_sg" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.rds_sg.id
  security_group_id        = aws_security_group.web_sg.id
}
```

For tagging we used `local.common_tags` and merged it with the resources unique name.
Backend of our RDS database is stored remotely in s3 bucket called `nazy-tf-bucket`, `session_7/backend.tfstate` file.
```
terraform {
  backend "s3" {
    bucket = "nazy-tf-bucket"
    key    = "session_7/backend.tfstate"
    region = "us-east-1"
  }
}
```

### Webserver (frontend)

- Application Load Balancer

Since we are working with Application, we have `Application Load Balancer` which provides the traffic to the Availability Zones, where our registered targets are sitting. As we know load balancer has to have a `Target group` first, for that we created target group with `Listeners rule HTTP`. Our ALB's security group configured with ingress open port `80` open to `0.0.0.0/0` and egress rule open to the world,   because we want our users to have access to our website and that's why it's internet-facing.
```
resource "aws_lb" "web_lb" {
  name               = "${var.env}-web-lb"
  internal           = false # internet-facing = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = data.aws_subnet_ids.default.ids

  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}-web-lb"
    }
  )
}
```

- Autoscaling Group and Launch Configuration.

Auto Scaling Group is a part of the frontend and for it's creation first we need configure Launch Configuration, it was created with `amazon linux 2` image id. And it has user_data.sh script, which will run during bootstrapping.
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

And the last resource to complete ASG is `aws_autoscaling_attachment` which connects our ALB(through Target group) to ASG.

```
resource "aws_autoscaling_attachment" "web_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  alb_target_group_arn   = aws_lb_target_group.web_tg.arn
}
```

Same as RDS (backend) state file, Webserver (frontend) state file also stored remotely in the same s3 bucket `nazy-tf-bucket` but different file frontend.tfstate. 
```
terraform {
  backend "s3" {
    bucket = "nazy-tf-bucket"
    key    = "session_7/frontend.tfstate"
    region = "us-east-1"
  }
}
```
`data_source` file has all the existing data sources, that we are fetching and to using in our configuration files. One of important data_source is when we fetch the state file of RDS from the S3 bucket, where we are storing the backend files of our resources.
```
data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket = "nazy-tf-bucket"
    key    = "session_7/backend.tfstate"
    region = "us-east-1"
  }
}
```
And used it fetch the Launch Configuration's security group, but before we have to output it first in the RDS (backend) folder.
```
output "web_sg_id" {
  value = aws_security_group.web_sg.id
}
```
```
resource "aws_launch_configuration" "web_lc" {
  name            = "${var.env}_web_lc"
  image_id        = data.aws_ami.amazon_linux2.id
  instance_type   = var.instance_type
  user_data       = data.template_file.user_data.rendered  
  security_groups = [data.terraform_remote_state.rds.outputs.web_sg_id]  # here
}
```

In `outputs.tf` we have some outputs that we fetched from the backend folders remote state file, and DNS name of ALB, so we don't have to go to the AWS console each time when we want to use it. The last file we is `variables.tf`, it has all the variables that we want to be adjusted depending on the environment, or different cases. The values for the variables are stored in `tfavars/dev.tf` file. 

### Tips and tricks in Terraform with outputs, locals, conditional expression and equality operators for boolean values.

- [Output values](https://www.terraform.io/docs/language/values/outputs.html)
- [Local Values](https://www.terraform.io/docs/language/values/locals.html)
- Combination of Equality Operators and Conditional Expressions for Boolean values.
    - [Conditional Expressions](https://www.terraform.io/docs/language/expressions/conditionals.html)
    - [Equality Operators](https://www.terraform.io/docs/language/expressions/operators.html#equality-operators)
    - [Boolean or bool](https://www.terraform.io/docs/language/expressions/types.html#bool)

### Outputs in Terraform

##### Example of output usage.

In order to get the outputs in frontend from the backend folder such as database_name, database_password or database_username we need to do the next steps:

1. Create ```outputs.tf``` with those values in ```backend folder```.

2. In ```frontend folder``` create a ```data source``` with the path to s3 bucket with backend.tfstate file.

3. Then create ```outputs.tf``` in ```frontend``` folder, on the value for the outputs we will refer to ```data "terraform_remote_state" "rds" {...}```, and terraform will fetch the data that we want to retrive from there. It is more clear when it shown below;

Backend `outputs.tf`,
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
`data_source.tf` in frontend folder,
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
Frontend `outputs.tf`,
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