locals {
  common_tags = {
    Environment = var.env
    Project     = var.project_name
  }
}

locals {
  public_subnet = {
    1 = { availability_zone = "us-east-1a", cidr_block = "10.0.1.0/24" },
    2 = { availability_zone = "us-east-1b", cidr_block = "10.0.2.0/24" },
    3 = { availability_zone = "us-east-1c", cidr_block = "10.0.3.0/24" }
  }
}

locals {
  private_subnet = {
    1 = { availability_zone = "us-east-1a", cidr_block = "10.0.11.0/24" },
    2 = { availability_zone = "us-east-1b", cidr_block = "10.0.12.0/24" },
    3 = { availability_zone = "us-east-1c", cidr_block = "10.0.13.0/24" }
  }
}

locals {
  ingress_rules = {
    1 = { from_port = 443, to_port = 443, protocol = "tcp", cidr_block = "0.0.0.0/0", description = "https_ingress", type = "ingress" },
    2 = { from_port = 80, to_port = 80, protocol = "tcp", cidr_block = "0.0.0.0/0", description = "http_ingress", type = "ingress" },
  }
}

# locals {
#   asg_scale_policy = {
#     1 = { name = "${var.env}_asg_out_policy",
#       scaling_adjustment     = 1,
#       adjustment_type        = "ChangeInCapacity",
#       cooldown               = 300,
#       autoscaling_group_name = aws_autoscaling_group.web_asg.name,
#       policy_type            = "SimpleScaling"
#     },
#     2 = { name = "${var.env}_asg_in_policy",
#       scaling_adjustment     = -1,
#       adjustment_type        = "ChangeInCapacity",
#       cooldown               = 300,
#       autoscaling_group_name = aws_autoscaling_group.web_asg.name,
#       policy_type            = "SimpleScaling"
#     },
#   }
# }

# locals {
#   cloudwatch_alarm = {
#     scale_out = {
#       comparison_operator = "GreaterThanOrEqualToThreshold",
#       alarm_name          = "${var.env}_add_capacity",
#       evaluation_periods  = "2",
#       protocol            = "tcp",
#       metric_name         = "CPUUtilization",
#       namespace           = "AWS/EC2",
#       period              = "120",
#       statistic           = "Average"
#       threshold           = "60"
#       alarm_description   = "This metric monitors webserver cpu utilization for scaling out"
#       alarm_actions       = [aws_autoscaling_policy.asg_scale_policy[1].arn]
#     },
#     scale_in = {
#       comparison_operator = "LessThanOrEqualToThreshold",
#       alarm_name          = "${var.env}_remove_capacity",
#       evaluation_periods  = "2",
#       protocol            = "tcp",
#       metric_name         = "CPUUtilization",
#       namespace           = "AWS/EC2",
#       period              = "120",
#       statistic           = "Average",
#       threshold           = "40",
#       alarm_description   = "This metric monitors webserver cpu utilization for scaling in",
#       alarm_actions       = [aws_autoscaling_policy.asg_scale_policy[2].arn]
#     },
#   }
# }