#!/bin/bash
sudo hostnamectl set-hostname wordpress-web
sudo amazon-linux-extras install -y php7.2
sudo yum install -y httpd 
sudo systemctl start httpd
sudo systemctl enable httpd
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo yum install php-gd -y
sudo yum install mysql -y 
sudo systemctl restart httpd
sudo cp -r wordpress/* /var/www/html
sudo chown -R apache:apache /var/www/html
sudo systemctl restart httpd