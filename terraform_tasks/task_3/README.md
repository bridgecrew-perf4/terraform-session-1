## Terraform project Wordpress (frontend)

This Project contains cofiguration files of the resources:

### Networking

- VPC
- 3 Public and Private Subnets
- Elastic IP 
- Nat Gateway
- Internet Gateway
- Route table association (public/private)

### Security Groups
 
- Web-server Security Group For Launch configuration
- Application Load Balancer Security Group

#### Elastic Load Balancer

- Application Load Balancer
- Target Group:
  - HTTP Listener
  - HTTPS Listener

### Application

- Launch Configuration
- Autoscaling group (frontend)

### DNS

- ACM Certification (Data source)
- Route 53 record

### Description

We a creating our own VPC where we used `for_each` and`locals` and  with combination  and also we used ```key```, ```value``` and  ```merge``` functions, using listed above helped us to create three subnets with one resource block and three route table association with another resource block. In this case we are working with ```map``` collection type constraints for the attribute values, however ```for_each``` can work with ```list``` and `set` types as well. We are passing different values for each subnet in `locals.tf` and `for_each` is itirating and getting values for each subnet and generating multiple subnets as well as route table association. If you want to use hardcoded VPC or use count meta-argument go here [terraform_vpc_examples](https://github.com/nazy67/terraform_vpc_examples), you will find an example of VPC's.

This project will cover the ```frontend``` of application which refers to the user interface, while ```backend``` means the database-server, application and database that work behind the scenes to deliver information to the customers.

Application Load Balancer was configured with Target Group and Listeners rules 80(redirected to 443) and 443 (fowarded to target group). It's internet facing(we want our website to be available for our users), target group gets created first and will load balancer will be provision. For the Litener rule 443 we attached our existing ```ACM Certificate``` that we fetched in in a data_source.tf file.   

We configured Auto Scaling Group as a part of frontend, but first we need configure Launch Configuration, it was created with ```amazon linux 2``` image id. And it has user data shell script, which installs apache and has a very simple index.html file with greeting in our webpage. We specified that we want our instances in private subnets otherwise we have to (if instances in public subnet we have to specifically say to ```associate_public_ip_address```). And the last resource in asg is attachment of asg to target group(which is ALB is created with). That's how we connect auto scaling group to application load balancer, which will provide the traffic to targeted instances.

We created two autoscaling group policies ```Simple scaling```, one of them will add (scale out) an instance if  ```CPU Utilization``` of the instance goes over 60% and another one will remove (scale in) an instance if CPU utilization goes down 40%. With that we also created two more resources ```cloudwatch_metric_alarm```
which will alarm us if we have overloaded instances or not enough CPU utilazing instances, we can be alarmed when instances are added and removed.    

The following arguments are only available to "SimpleScaling" type policies:

- cooldown - (Optional) The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start.
- scaling_adjustment - (Optional) The number of instances by which to scale. adjustment_type determines the interpretation of this number (e.g., as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity.

Our state file will be stored in S3 bucket as we configured in backend.tf file, it is common to store your state file remotely when you work with a team.

"A" type Route 53 record was created with alias of Application Load Balancer, 

### Notes

- You may want to omit desired_capacity attribute from attached aws_autoscaling_group when using autoscaling policies. It's good practice to pick either manual or dynamic (policy-based) scaling. [omit desired capacity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy)

### Usefule links

[Dynamic tagging](https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each)

[Step and simple scaling policies for Amazon EC2 Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scaling-simple-step.html)