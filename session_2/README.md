## Terraform installation on EC2 instance.

### Description

To start we created an EC2 instance which we named ```Terraform server```  we created that instance with our ssh-key, so we can ssh into it and run commands and install Terraform (binary). To do that we go to this website:

```
https://www.terraform.io/downloads.html
```

where we copy the link of the LINUX 64bit. We run next command on CLI of Terraform server with wget command:
```
wget  https://releases.hashicorp.com/terraform/0.14.9/terraform_0.14.9_linux_amd64.zip
```

when we run a command above we installed unzipped terraform, to unzip it we run:

```
unzip terraform_0.14.9_linux_amd64.zip
```

after that if we run ls -l we can see:

```
drwxrwxr-x 2 ec2-user ec2-user       23 Apr  4 23:10 session_2
-rwxr-xr-x 1 ec2-user ec2-user 82741780 Mar 24 18:42 terraform
-rw-rw-r-- 1 ec2-user ec2-user 33787465 Mar 24 18:57 terraform_0.14.9_linux_amd64.zip
```

and since the terraform is a binary we move it under /usr/bin/:

```
sudo mv terraform /usr/bin/
```

if we run which terraform we will get the output:

```
/usr/bin/terraform
```
To check the version of terraform we installed we check:
```
terraform -version
```
your output should look like this:
 ```
 Terraform v0.14.9
 ```

And you are all set!

After that we created a directory session_2, where we created our first configuration file ```main.tf``` (all terraform files have .tf extension) which has an EC2 resource, to provision that instance with ```Terraform server``` we have to give credentials such as ```access-key``` and ```secret-key```, but instead we created an EC2 role and attached it to it and were able to apply our code on AWS console. 
