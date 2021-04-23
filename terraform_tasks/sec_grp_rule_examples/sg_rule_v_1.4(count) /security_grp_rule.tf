# This example of security group rule is very similar to previous v 1.3, the only
# difference is we used list(objects) instead of list(tuple). We build the variables
# file little different as well, but the same function "length" and count meta-
# argument with count.index expression were used. Ant we can provision 2 ingress rules
# (ssh and http) and egress rule.

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
  type              = var.sg_ingress_rules[count.index].type
  from_port         = var.sg_ingress_rules[count.index].from_port
  to_port           = var.sg_ingress_rules[count.index].to_port
  protocol          = var.sg_ingress_rules[count.index].protocol
  cidr_blocks       = [var.sg_ingress_rules[count.index].cidr_blocks]
  description       = var.sg_ingress_rules[count.index].description
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "egress" {
  count             = length(var.sg_egress_rule)
  type              = var.sg_egress_rule[count.index].type
  from_port         = var.sg_egress_rule[count.index].from_port
  to_port           = var.sg_egress_rule[count.index].to_port
  protocol          = var.sg_egress_rule[count.index].protocol
  cidr_blocks       = [var.sg_egress_rule[count.index].cidr_blocks]
  security_group_id = aws_security_group.web_sg.id
}