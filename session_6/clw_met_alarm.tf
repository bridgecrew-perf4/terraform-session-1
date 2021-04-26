resource "aws_autoscaling_policy" "asg_scale_up_policy" {
  name                   = "${var.env}_asg_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type = "SimpleScaling"
}
resource "aws_cloudwatch_metric_alarm" "cpu_" {
  alarm_name          = "${var.env}_asg_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.bar.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.asg_policy.arn]
}

resource "aws_autoscaling_policy" "example-cpu-policy" {
#name = "example-cpu-policy"
#autoscaling_group_name = "${aws_autoscaling_group.example-autoscaling.name}"
#adjustment_type = "ChangeInCapacity"
#scaling_adjustment = "1"
#cooldown = "300"
#policy_type = "SimpleScaling"
}
resource "aws_cloudwatch_metric_alarm" "example-cpu-alarm" {
alarm_name = "example-cpu-alarm"
alarm_description = "example-cpu-alarm"
comparison_operator = "GreaterThanOrEqualToThreshold"
evaluation_periods = "2"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = "120"
statistic = "Average"
threshold = "30"
dimensions = {
"AutoScalingGroupName" = "${aws_autoscaling_group.example-autoscaling.name}"
}
actions_enabled = true
alarm_actions = ["${aws_autoscaling_policy.example-cpu-policy.arn}"]
}