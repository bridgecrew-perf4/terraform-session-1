# In this example of sg_rule we used "count" meta-argument with "count.index" expression
# and "length" functions, where we were able to provision 2 ingress rules (ssh and http)
# and egress rule. The reason for putting an extra [] signs for cidr blocks is because 
# it's a list, which requires to be inside of the []. Another thing to mention you can 
# either keep the list inside of the variables.tf or dev.tf, either way it will work.

# Webserver security group
resource "aws_security_group" "web_sg" {
  name        = "${var.env}_web_sg"
  description = "Allow inbound traffic"
  #vpc_id      = aws_vpc.my_vpc.id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_web_sg"
    }
  )
}

resource "aws_security_group_rule" "ingress_rules" {
  count             = length(var.sg_ingress_rules)
  from_port         = var.sg_ingress_rules[count.index][0]
  to_port           = var.sg_ingress_rules[count.index][1]
  protocol          = var.sg_ingress_rules[count.index][2]
  cidr_blocks       = [var.sg_ingress_rules[count.index][3]]
  description       = var.sg_ingress_rules[count.index][4]
  type              = var.sg_ingress_rules[count.index][5]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "egress" {
  count             = length(var.sg_egress_rule)
  from_port         = var.sg_egress_rule[count.index][0]
  to_port           = var.sg_egress_rule[count.index][1]
  protocol          = var.sg_egress_rule[count.index][2]
  cidr_blocks       = [var.sg_egress_rule[count.index][3]]
  type              = var.sg_egress_rule[count.index][4]
  security_group_id = aws_security_group.web_sg.id
}