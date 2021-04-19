#!/bin/bash 
sudo yum update -y
sudo hostnamectl set-hostname wordpress-db
sudo yum install mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation <<EOF

y
password123
password123
y
y
y
y
EOF
mysql -uroot -ppassword123<<MYSQL_SCRIPT
CREATE DATABASE wordpressdb;
CREATE USER wordpressuser@'${wordpress_private_ip}' IDENTIFIED BY 'redhat123';
GRANT ALL PRIVILEGES ON wordpressdb.* TO wordpressuser@'${wordpress_private_ip}' IDENTIFIED BY 'redhat123';
FLUSH PRIVILEGES;
EXIT;
MYSQL_SCRIPT
sudo systemctl restart mariadb