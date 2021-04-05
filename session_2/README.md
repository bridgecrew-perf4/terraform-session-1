## Terraform installation on EC2 instance and Provisioning  EC2 resource with Terraform server which has attached IAM role.

### Description

To start we create EC2 instance which we give a name ```Terraform server``` on AWS console and install Terraform binary inside of it so we created that instance with out ssh-key so we can ssh into it and run commands and install terraform. To do that we go to this website

```
https://www.terraform.io/downloads.html
```
where we copy the link of the LINUX 64bit. We run next commands:
```
wget  https://releases.hashicorp.com/terraform/0.14.9/terraform_0.14.9_linux_amd64.zip
```

when we run a command above we install unzipped terraform, to unzip it we run:

```
unzip terraform_0.14.9_linux_amd64.zip
```

after that if we run ls -l we can see:

```
drwxrwxr-x 2 ec2-user ec2-user       23 Apr  4 23:10 session_2
-rwxr-xr-x 1 ec2-user ec2-user 82741780 Mar 24 18:42 terraform
-rw-rw-r-- 1 ec2-user ec2-user 33787465 Mar 24 18:57 terraform_0.14.9_linux_amd64.zip
```

and since the terraform is a binary we move it under:

```
sudo mv terraform /usr/bin/
```

if we run which terraform we will get the next output:

```
/usr/bin/terraform
```
And you are all set.

In this session we created provisioned an EC2 instance with Terraform server that we created earlier, instead of using credentials such as ```access-key``` and ```secret-key``` we attached a EC2 role to our Terraform server and were able to apply our code
