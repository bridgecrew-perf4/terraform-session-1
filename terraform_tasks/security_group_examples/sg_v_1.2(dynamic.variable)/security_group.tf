# This security group contains a "dynamic block"  which creates 2 inbound rules 
# 22 and 80. In variables.tf we gave the definition for each rule and "for_each"
# meta-argument is looping and getting correct data for each security roup rule. 
# Which makes our security group reusable, where all the values in variables.tf
# can be changed depending of the ports you need. 

resource "aws_security_group" "web_sg" {
  name        = "${var.env}_web_sg"
  description = "allow inbound/outbound traffic"

  dynamic "ingress" {
    for_each = var.web_ingress_ports
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port 
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidrs
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.env}_web_sg"
    Environment = var.env
    Project     = var.project_name
  }
}