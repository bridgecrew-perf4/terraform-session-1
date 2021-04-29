## Terraform project (frontend)

Terraform is plugin based tool and all plugins are in ```.terraform``` folder, whenever you run ```terraform init``` it will initialize the working directory and install all needed plugins. Additional to ```.terraform``` folder ```.terraform.lock.hcl``` file gets created as well, which prevents from getting corrupted of your ```terraform.tfstate``` file.

# In this template "for_each" function with "local" variables were used for creation 
# of subnets and and route table association. In our case we are working with "map" value, 
# although "for_each" can work with "string" value as well as with "map" value. We are passing
# separate settings for each subnet, while using the keys/values for generating subnets.

adjustment_type:

Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity.

policy_type:

The policy type, either "SimpleScaling", "StepScaling" or "TargetTrackingScaling". If this value isn't provided, AWS will default to "SimpleScaling."

The following arguments are only available to "SimpleScaling" type policies:

- cooldown - (Optional) The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start.
- scaling_adjustment - (Optional) The number of instances by which to scale. adjustment_type determines the interpretation of this number (e.g., as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity.

[Step and simple scaling policies for Amazon EC2 Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scaling-simple-step.html)

We strongly recommend that you use a target tracking scaling policy to scale on a metric like average CPU utilization or the RequestCountPerTarget metric from the Application Load Balancer.

### Notes

- You may want to omit desired_capacity attribute from attached aws_autoscaling_group when using autoscaling policies. It's good practice to pick either manual or dynamic (policy-based) scaling. [omit desired capacity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy)