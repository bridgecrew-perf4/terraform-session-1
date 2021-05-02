# resource "aws_autoscaling_policy" "asg_scale_out_target_tracking_policy" {
#   name = "${var.env}_scale_out_policy"
#   policy_type = "TargetTrackingScaling"
#   autoscaling_group_name = aws_autoscaling_group.web_asg.name
#   estimated_instance_warmup = 200
  
#   target_tracking_configuration {
#   predefined_metric_specification {
#   predefined_metric_type = "ASGAverageCPUUtilization"
#   }
  
#       target_value = "60"
  
#   }
# }

# resource "aws_cloudwatch_metric_alarm" "cloudwatch_cpu_util_alarm_scale_out" {
#   alarm_name          = "${var.env}_add_capacity"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "60"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.web_asg.name
#   }

#   actions_enabled   = true
#   alarm_description = "This metric monitors webserver cpu utilization for scaling out"
#   alarm_actions     = [aws_autoscaling_policy.asg_scale_out_target_tracking_policy.arn]
# }

# resource "aws_autoscaling_policy" "asg_scale_in_target_tracking_policy" {
#   name = "${var.env}_scale_in_policy"
#   policy_type = "TargetTrackingScaling"
#   autoscaling_group_name = aws_autoscaling_group.web_asg.name
#   estimated_instance_warmup = 200
  
#   target_tracking_configuration {
#   predefined_metric_specification {
#   predefined_metric_type = "ASGAverageCPUUtilization"
#   }
  
#       target_value = "40"
  
#   }
# }

# resource "aws_cloudwatch_metric_alarm" "cloudwatch_cpu_util_alarm_in" {
#   alarm_name          = "${var.env}_remove_capacity"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "60"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.web_asg.name
#   }

#   actions_enabled   = true
#   alarm_description = "This metric monitors webserver cpu utilization for scaling out"
#   alarm_actions     = [aws_autoscaling_policy.asg_scale_in_target_tracking_policy.arn]
# }

#We strongly recommend that you use a target tracking scaling policy to scale on a metric like average CPU utilization or the RequestCountPerTarget metric from the Application Load Balancer.