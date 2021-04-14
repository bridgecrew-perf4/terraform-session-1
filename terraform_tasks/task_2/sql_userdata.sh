#!/bin/bash 
sudo hostnamectl set-hostname wordpress-db
sudo yum install mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb