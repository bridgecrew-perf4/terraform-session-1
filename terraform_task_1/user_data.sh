#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "Hello from web instance" > /var/www/html/index.html
sudo chown -R apache:apache /var/www/html/