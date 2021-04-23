# Providers variables
aws_region = "us-east-1"
# Security group variables
sg_ingress_rules = [
        [22, 22, "tcp", "0.0.0.0/0", "ssh_ingress", "ingress"],
        [80, 80, "tcp", "0.0.0.0/0", "http_ingress", "ingress"],
    ]

sg_egress_rule = [
    [0, 0, "-1", "0.0.0.0/0", "egress"]
  ]    
# Tags variables
env          = "dev"
project_name = "application"