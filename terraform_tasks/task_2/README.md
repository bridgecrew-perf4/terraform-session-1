### WordPress using Terraform

Still in progress ...

mysql_secure_installation

CREATE DATABASE wordpressdb;
CREATE USER admin@10.0.1.84 IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON wordpressdb.*  TO admin@10.0.1.84 IDENTIFIED BY '';
FLUSH PRIVILEGES;
EXIT