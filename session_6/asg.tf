resource "aws_autoscaling_group" "web_asg" {
  name                      = "${var.env}_web_asg"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB" # "EC2"
  desired_capacity          = 3
  force_delete              = true
  launch_configuration      = aws_launch_configuration.web_lc.name
  vpc_zone_identifier       = [aws_subnet.public_subnet[1].id, aws_subnet.public_subnet[2].id, aws_subnet.public_subnet[3].id]
}

resource "aws_autoscaling_attachment" "web_lb_asg_attachment" {
  alb_target_group_arn   = aws_lb_target_group.web_tg.arn
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
}