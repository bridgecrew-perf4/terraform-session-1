# Providers variables
aws_region = "us-east-1"
# Security group variables
web_sg_tcp_ports = ["22", "80"]
egress_port      = 0
ingress_protocol = "tcp"
egress_protocol  = "-1"
cidr_block       = "0.0.0.0/0"
out_traffic_type = "egress"
in_traffic_type  = "ingress"
# Tags variables
env          = "dev"
project_name = "application"