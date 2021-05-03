# resource "aws_cloudwatch_metric_alarm" "cpu_util_add_alarm" {
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
#   alarm_actions     = [aws_autoscaling_policy.asg_scale_out_policy.arn]
# }

# resource "aws_cloudwatch_metric_alarm" "cpu_util_remove_alarm" {
#   alarm_name          = "${var.env}_remove_capacity"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "40"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.web_asg.name
#   }

#   actions_enabled   = true
#   alarm_description = "This metric monitors webserver cpu utilization for scaling in"
#   alarm_actions     = [aws_autoscaling_policy.asg_scale_in_policy.arn]
# }