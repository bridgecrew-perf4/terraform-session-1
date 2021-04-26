# Scale out policy and cloudwatch alarm
resource "aws_autoscaling_policy" "asg_scale_out_policy" {
  name                   = "${var.env}_asg_out_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_up_alarm" {
  alarm_name          = "${var.env}_web_up_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
  
  actions_enabled = true
  alarm_description = "This metric monitors webserver cpu utilization for scaling out"
  alarm_actions     = [aws_autoscaling_policy.asg_scale_up_policy.arn]
}

# Scale in policy and cloudwatch alarm
resource "aws_autoscaling_policy" "asg_scale_in_policy" {
  name                   = "${var.env}_asg_in_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_down_alarm" {
  alarm_name          = "${var.env}_web_down_alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "40"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  actions_enabled = true
  alarm_description = "This metric monitors webserver cpu utilization for scaling in"
  alarm_actions     = [aws_autoscaling_policy.asg_scale_in_policy.arn]
}