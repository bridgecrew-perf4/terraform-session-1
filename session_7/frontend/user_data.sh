#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install epel -y
sudo amazon-linux-extras install php8.0 -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo yum install php-gd -y
sudo yum install mysql -y
sudo cp -r wordpress/* /var/www/html
sudo chown -R apache:apache /var/www/html
sudo systemctl restart httpd