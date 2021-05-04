## Terraform project Wordpress (frontend)

This project will cover the ```frontend``` of application which is user interface, while ```backend``` means the database-server, application and database that work behind the scenes to deliver information to the customers. Our state file will be stored in S3 bucket as we configured in backend.tf file, it is common to store your state file remotely when you work with a team. This Project contains cofiguration files of resources:

### Networking

- VPC
- 3 Public and Private Subnets
- Elastic IP 
- Nat Gateway
- Internet Gateway
- Route table association (public/private)

### Security Groups

- Application Load Balancer Security Group 
- Web-server Security Group For Launch configuration

#### Application Load Balancer
 
- Target Group:
  - HTTP Listener
  - HTTPS Listener

### Application

- Launch Configuration
- Autoscaling group (frontend)
  - Auto Scaling Policies (scale in/out)
  - Cloud Watch Alarm

### DNS

- ACM Certification (Data source)
- Route 53 record

### Description

- VPC

We a creating our own VPC, where we used combination of `for_each` and `locals` and functions `key`, `value` and  `merge`. Using them helped us to avoid repeating similar resources as subnets and route table association, so with one resource block  were able to create three resource blocks. Also we used `map` collection type constraint for attribute values, but `for_each` can work with `list` and `set` types as well. We are passing different values for each subnet in `locals.tf` and `for_each` is itirating and getting values for each subnet and Terraform generating multiple subnets and route table association. If you would like to learn more about it go here [terraform_vpc_examples](https://github.com/nazy67/terraform_vpc_examples), you will find an example of VPC.

- Security Groups

1. Application Load Balancer Security Group. We have two ingress rules HTTP (80) and HTTPS (443) open to the world (0.0.0.0/0), and egress rule with `-1` protocol which means everything to 0.0.0.0/0. In Terraform we have to specify egress rule, if not Terraform will not create it. 
2. Web-server Security Group For Launch configuration,  HTTP port open to 0.0.0.0/0 as well as egress rule.

- Application Load Balancer

Application Load Balancer was configured with Target Group and Listeners rules 80(redirected to 443) and 443 (fowarded to target group). It's internet facing (we want our website to be available to users) and Target group has a health check if, the health of our instances will fail ASG will add a new instance. For the Litener rule 443 we attached our existing `ACM Certificate` that we fetched in in a acm.tf file. 
```
data "aws_acm_certificate" "my_certificate" {
  domain   = "nazydaisy.com"
  statuses = ["ISSUED"]
}
```

- Launch Configuration and Auto Scaling Group

We configured Launch Configuration first as part of Auto Scaling Group, it will be  created with ```amazon linux 2``` image id, which data source fetched from Amazon since it's existion resource.  And Launch Configuraion has user_data.sh script, which installs enables and starts Apache, and has a very simple index.html file with greeting in our website. In Auto Scaling Group we specified that we want our instances to be on private subnets (it has elastic IP), otherwise we have to associate public IP address if instances in public subnets. The last resource blockd in Auto Scaling Group is attachment of ASG to ALB (through Target group), and ALB will provide the traffic to Private Subnets where our targeted Instances are sitting.
ASG has a different way of tagging, it requres map of tags, but with the help of  dynamic block we creted tags this way,
```
  tag {
    key                 = "Name"
    value               = "${var.env}_web_server"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.common_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
```
If you want to read about it more check out [Dynamic tagging](https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each).

- Simple Scaling policy (scale in/out) and Cloud Watch Alarm.

We created two Simple Scaling policies with type `Simple scaling`, one of them will add (scale out) an instance if  ```CPU Utilization``` of the instance goes over 60% and another one will remove (scale in) an instance if CPU utilization goes down 40%. With that we also created two more resources `cloudwatch_metric_alarm` which will alarm us if we have overloaded instances or not enough CPU utilazed instances, that's how we can keep a track when instances are added and removed.    

The following arguments are only available to "SimpleScaling" type policies:

- cooldown - (Optional) The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start.
- scaling_adjustment - (Optional) The number of instances by which to scale. adjustment_type determines the interpretation of this number (e.g., as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity. To read more about [Simple Scaling policy](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scaling-simple-step.html)

- Route 53 record.

"A" (IPv4 and some AWS resources) type Route 53 record was created which will route traffic to alias Application Load Balancer with `Simple routing policy`. For that we fetched an existing zone name in data_source.tf and we were able to get zone_id from it, keep in mind that in AWS zone name always ends with `.` like `nazydaisy.com.`.
```
data "aws_route53_zone" "my_zone" {
  name = var.zone_name
}
```

### Notes

- You may want to omit desired capacity attribute from attached aws autoscaling group when using autoscaling policies. It's good practice to pick either manual or dynamic (policy-based) scaling. [Omit desired capacity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy)