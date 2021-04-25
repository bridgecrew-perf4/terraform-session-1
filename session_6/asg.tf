# resource "aws_autoscaling_group" "web_asg" {
#   vpc_zone_identifier = data.aws_subnet_ids.default.ids
#   desired_capacity   = 1
#   max_size           = 2
#   min_size          = 1
#   force_delete = true
#   launch_configuration = aws_launch_configuration.web_lc.name

#   tag {
#     key                 = "Name"
#     value               = "${var.env}_web_asg"
#     propagate_at_launch = true
#   }

#   instance_refresh {
#     strategy = "Rolling"
#     preferences {
#       min_healthy_percentage = 50
#     }
#   }
# }

resource "aws_autoscaling_group" "web_asg" {
  name                      = "${var.env}_web_asg"
  max_size                 = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB" # "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.web_lc.name
  vpc_zone_identifier       = data.aws_subnet_ids.default_subnet.ids
}