## Terraform task one

- Create an EC2 instance with following configurations:
  - region: us-west-2
  - ami: centos-7
  - secirity group: default
  - vpc: default
  - subnet: us-west-2b
  - tags: 
    Name = "web-instance"
    Environment = "dev"
  - user_data: 
    #!/bin/bash
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl restart httpd
    sudo echo “Hello from Web Instance” > /var/www/html/index.html 
    sudo chown -R apache:apache /var/www/html/