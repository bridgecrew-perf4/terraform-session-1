#!/bin/bash
sudo hostnamectl set-hostname wordpress-db
#sudo amazon-linux-extras install -y php7.2
#sudo yum install php-gd -y
sudo yum install mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable