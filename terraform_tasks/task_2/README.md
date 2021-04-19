### WordPress using Terraform

#### Network
Virtual Private Cloud (VPC)

- Internet Gateway
- Nat Gateway
- 3 Public Subnets
- 3 Private Subnets
- Public Route Table
- Private Route Table

#### Security Groups

- Wordpress-web Security Group
- Wordpress-database Security Group

#### Application

- WordPress-web (Frontend)
- Wordpress-database (Backend)

#### DNS

- Route 53

<p>
For the Network  part VPC with CIDR 10.0.0.0/16 was created with 3 public and 3 private subnets with CIDR blocks:
</p>
Public subnet cird blocks       
- 10.0.1.0/24       
- 10.0.2.0/24        
- 10.0.3.0/24

Private subnet cidr blocks
- 10.0.11.0/24
- 10.0.12.0/24
- 10.0.13.0/24

<p>
After that Internet Gateway was created attached to VPC which brings the Internet.
</p>
<p>
For Private subnets Internet comes with NAT Gateway it will be created with Elastic IP address (the reason behind it,if you want to updates your website it has to have static IP) which will attached to one of the public subnets, because in that manner private subnets won’t be open to the world it's secure.
</p>
<p>
The next resource is Route tables (public and private) 3 public subnets will be assosiated with Public-RT attached with Internet Gateway and 3 private subnets will be assosiated with Private-RT which is attached to Nat Gateway.
</p>
The next step is security groups:

- Wordpress-web security group with open ports:

1. Port 22 from ```terraform-server``` (we can ssh into this server because it was created it with ssh-key of ```terraform-server```)
2. Port 80 to ```0.0.0.0/0``` we want our webserver to be accesible to our customers.
3. Port 3306 to ```wordpress-db security group```
4. Egress open to "0.0.0.0/0" (in terraform you have to specify egress rule)

- Wordpress-database Security Group:

1. Port 22 to ```terrafom-server```(because we want to get inside and create a database)
2. Port 3306 to ```wordpress-web-sg``` (we want to establish connection between wordpress-wb and wordpress-database)
3. Egress from "0.0.0.0/0" (because when we want to run some updates in our database we have to have outbound port open)

#### Wordpress-database 

Wordpress_database will be created in a private subnet with AMI Amazon LINUX 2 image id, which terraform will get from ```data_source.tf``` and instance type will be t2.micro. In user data  section we used ```data source template_file```, which will get ```sql_userdata.sh```, it will install mariadb, starts and enables it, as well as runs ```mysql_secure_installation``` for secure installation of mariadb (it gives a root user new password, we will need it when we create database later), and in addition  to that we also wrapped database creation inside of that script too ```mysql -uroot -ppassword123```. So basically our script will install and create a database while booting, and it looks like this:

```
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
CREATE USER wordpressuser@'${wordpress_private_ip}' IDENTIFIED BY 'password123';
GRANT ALL PRIVILEGES ON wordpressdb.* TO wordpressuser@'${wordpress_private_ip}' IDENTIFIED BY 'password123';
FLUSH PRIVILEGES;
EXIT;
MYSQL_SCRIPT
sudo systemctl restart mariadb
```
In the script above we mentioned '${wordpress_private_ip}' this is variable was described in data source template_file. It will be used to create a wordpressuser for wordpress_web in wordpress_database instance. And also ```y``` means ```yes``` and it answers the questions below:

```
[root@wordpress-db ~]# mysql_secure_installation

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

Set root password? [Y/n] y
New password: 
Re-enter new password: 
Password updated successfully!
Reloading privilege tables..
 ... Success!

By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] y
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.
```

Since we already created our database without getting inside of wordpress_database server, we don't have to follow the instructions below. But if we didn't wrap script above,  our next step would be to ssh into webserver-database and run ```mysql -u root -p``` and give root user password and create a database. The process looks like this:

```
[root@wordpress-db ~]# mysql -u root -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 10
Server version: 5.5.68-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> CREATE DATABASE wordpressdb;
Query OK, 1 row affected (0.00 sec)

MariaDB [(none)]> CREATE USER wordpressuser@'${wordpress_web_server_private_ip}' IDENTIFIED BY 'passoword123';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON wordpressdb.*  TO wordpressuser@${wordpress_web_server_private_ip} IDENTIFIED BY 'password123';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> exit
Bye
```
And restart mariadb.

#### Wordpress-web

Same as wordpress-database wordpress-web will be created with Amazon LINUX 2 machine (AMI) and instance type t2.micro, and bash script was added in the user data section ```web_userdata.sh```. This bash script will install a LAMP stack (skipping database installation) php, httpd, mysql-agent and Wordpress package and unzippes it.

#### Route 53

Route_53.tf created "A" record www.nazydaisy.com in AWS with the public IP of the wordpress_web instance.

With that info  when  you go to www.nazydaisy.com and entered database name "wordpressdb" , user that I created "wordpressuser" and "password123", and database private ip address. You should be able to get cofigure WordPress website.

#### Notes

- Important thing keep in mind when we want our security groups to be created in our VPC we have to let know terraform about it, otherwise it gets created in default VPC.
