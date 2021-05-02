## Terraform installation on EC2 instance.

### Description

Terraform is plugin based tool and all plugins are in ```.terraform``` folder, whenever you run ```terraform init``` it will initialize the working directory and install all needed plugins. In addition to ```.terraform``` folder ```.terraform.lock.hcl``` file gets created as well, which prevents from getting corrupted of your local ```terraform.tfstate``` file.

To start we created an EC2 instance which we named ```Terraform server``` we created that instance with our ssh-key, so we can ssh into it and run commands and install Terraform (binary). To do that we go to this website:

```
echo $PATH

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

After that we created a directory session_2, where we created our first configuration file ```main.tf``` (allterraform files have .tf extension) which has an EC2 resource, to provision that instance with ```Terraformserver``` we have to give credentials such as ```access-key``` and ```secret-key```, but instead we createdan EC2 role and attached it to it and we are good to go. When provision resources with terraform we also haveto create ```providres.tf``` file that's how terraform knows which provider we are using and which cloudprovider we want to provision our resource.

## Notes

- Terraform is a binary, it’s plugin based architecture.

## Additional questions

#### Why do we have to move our terraform file under /usr/bin/ ?
```
- /bin : For binaries usable before the /usr partition is mounted. This is used for trivial binaries used in the very early boot stage or ones that you need to have available in booting single-user mode. Think of binaries like cat, ls, etc.

- /sbin : Same, but for binaries with superuser (root) privileges required.

- /usr/bin : Same as first, but for general system-wide binaries.

- /usr/sbin : Same as above, but for binaries with superuser (root) privileges required.
```

## Useful links

[Download Terraform](https://www.terraform.io/downloads.html)

[Filesystem Hierarchy Standard (FHS) in LINUX](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)