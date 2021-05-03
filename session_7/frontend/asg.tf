# Autoscaling group
resource "aws_autoscaling_group" "web_asg" {
  name                      = "${var.env}-asg"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.web_lc.name
  vpc_zone_identifier       = data.aws_subnet_ids.default.ids

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "web_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  alb_target_group_arn   = aws_lb_target_group.web_tg.arn
}