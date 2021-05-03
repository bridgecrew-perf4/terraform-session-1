resource "aws_autoscaling_policy" "asg_scale_out_target_tracking_policy" {
  name                      = "${var.env}_scale_out_policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.web_asg.name
  estimated_instance_warmup = 200

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = "60"

  }
}

resource "aws_autoscaling_policy" "asg_scale_in_target_tracking_policy" {
  name                      = "${var.env}_scale_in_policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.web_asg.name
  estimated_instance_warmup = 200

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = "40"

  }
}

# We strongly recommend that you use a target tracking scaling policy to scale on a 
# metric like average CPU utilization or the RequestCountPerTarget metric from the 
# Application Load Balancer. Target tracking policy will create and manages cloud 
# watch alarm. [Target tracking scaling policies for Amazon EC2 Auto Scaling
# ](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scaling-target-tracking.html)