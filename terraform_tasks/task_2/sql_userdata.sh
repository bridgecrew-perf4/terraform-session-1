#!/bin/bash 
sudo yum update -y
sudo hostnamectl set-hostname wordpress-db
sudo yum install mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
#sudo mysql_secure_installation <<EOF
#
#y
#redhat123
#redhat123
#y
#y
#y
#y
#EOF