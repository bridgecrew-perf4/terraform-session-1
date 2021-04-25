#!/bin/bash
sudo yum install httpd -y
sudo echo “Hello from ${env} environment” >> /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd