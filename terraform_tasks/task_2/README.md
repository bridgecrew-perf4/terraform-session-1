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

For the Network  part VPC with CIDR 10.0.0.0/16 was created with 3 public and 3 private subnets with CIDR blocks:

Public subnet      Private subnet 

10.0.1.0/24        10.0.11.0/24
10.0.2.0/24        10.0.12.0/24
10.0.3.0/24        10.0.13.0/24

After that Internet Gateway was created attached to VPC which brings the Internet.

For Private subnets Internet comes with NAT Gateway it will be created with Elastic IP address (the reason behind it,if you want to updates your website it has to have static IP) which will attached to one of the public subnets, because in that manner private subnets won’t be open to the world it's secure.

The next resource is Route tables (public and private) 3 public subnets will be assosiated with Public-RT attached with Internet Gateway and 3 private subnets will be assosiated with Private-RT which is attached to Nat Gateway.

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

Wordpress database will be created in public subnet with AMI Amazon LINUX 2 machine which terraform did get from ```data_source.tf``` and t2.micro instance type was used. User data will install mariadb, starts and enables it. Also instead of running ```mysql_secure_installation``` inside of wordpress-database I wrapped it inside of the ```sql_userdata.sh``` where mariadb will be installed inside of database securely, and give a root user new password (we will need it when we create database) it look like this: 
```
#!/bin/bash 
..........
sudo mysql_secure_installation <<EOF

y
redhat123
redhat123
y
y
y
y
EOF
```
where ```y``` means yes and it answers questions below:
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

After that when we ssh into webserver-database and run ```mysql -u root -p``` and give created roots password and create a database:
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

MariaDB [(none)]> CREATE USER admin@10.0.1.94 IDENTIFIED BY 'redhat123';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON wordpressdb.*  TO admin@10.0.1.199 IDENTIFIED BY 'redhat123';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> exit
Bye
```
And restart mariadb.

#### Wordpress-web

Same as wordpress-database, for wordpress-web Amazon LINUX 2 machine (AMI) and t2.micro instance type was used and bash script was added in the user data section ```web_userdata.sh```. This bash script will download php, httpd, mysql-agent and Wordpress package and unzippes it.

#### Route 53

Route_53.tf created "A" record www.nazydaisy.com in AWS with the public IP of the wordpress-web instance.

With that info  when  you go to www.nazydaisy.com and entered database name "wordpressdb" , user that I created "wordpressuser" and "password", and database private ip address. You should be able to get cofigure WordPress website.

#### Notes

- Important thing keep in mind when we want our security groups to be creatd in our VPC we have to let know terraform about it, otherwise it gets created in default VPC.