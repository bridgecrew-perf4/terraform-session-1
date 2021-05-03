# resource "aws_autoscaling_policy" "asg_scale_out_policy" {
#   name                   = "${var.env}_scale_out_policy"
#   scaling_adjustment     = 1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   autoscaling_group_name = aws_autoscaling_group.web_asg.name
#   policy_type            = "SimpleScaling"
# }

# resource "aws_autoscaling_policy" "asg_scale_in_policy" {
#   name                   = "${var.env}_scale_in_policy"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   autoscaling_group_name = aws_autoscaling_group.web_asg.name
#   policy_type            = "SimpleScaling"
# }