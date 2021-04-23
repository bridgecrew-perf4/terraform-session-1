# Providers variables
aws_region = "us-east-1"
# Security group variables
egress_port      = 0
ingress_protocol = "tcp"
egress_protocol  = "-1"
cidr_block       = "0.0.0.0/0"
http_port        = "80"
ssh_port         = "22"
out_traffic_type = "egress"
in_traffic_type  = "ingress"
# Tags variables
env          = "dev"
project_name = "application"