#### Terraform backend

If you are a team who is using Terraform to manage your infrastructure, terraform recommends using remote backend file instead of storing your tfstate file locally. Storing your backend in AWS S3 bucket is one of the options of how you can do it. To do that we have to configure backend file first:
```
terraform {
  backend "s3" {
    bucket = "my-tf-bucket"
    key    = "dev/instance.tfstate"
    region = "us-east-1"
  }
}
```
 When we store our tfstate file remotely it allows us to be more flexible for working with  group of people(team), because all the team members can have access to it and it will make teamwork to go smooth. But before we configure storing our tfstate in S3 bucket, we have to make sure it exists. After that we run terraform init, which initializes storing our backend in given remote S3 bucket. Having a remote backend helps us to store in one S3 bucket different tfstate files for different environments. So if you want to provision the same infra, but for different environment we can use ```folder structure```. If we don't do it that, each time we run terraform apply, it will destroy existing infra and recreats the infra for diffenrent environment. So folder structure is comes very handy to isolating environments and provision our infra without having any effect on existing infrastructure.

 ### "element" function

 The goal of the element function is to retrive a single element from the a given list. List it's a list of items inside of square brackets [] separated by commas. It can be number of items and they can be different types (integer, float, string etc.).
```
element(list, index)
```
So element retrives an item from a list using index, the index is zero-based. 
Element function in terraform helps us to create repeating resources with one resource block. For example:
```
# Public Subnets

resource "aws_subnet" "public_subnet_" {
  count             = length(var.subnet_azs)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.pub_cidr_subnet, count.index)
  availability_zone = element(var.subnet_azs, count.index)
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_pub_sub_${count.index}"
    }
  )
}

# Subnet variables

variable "subnet_azs" {
  type        = list(string)
  description = "The availabitily zones where terraform deploys your infra"
}

variable "pub_cidr_subnet" {
  type        = list(string)
  description = "cird blocks for the public subnets"
}

# Subnet dev.tfvars

subnet_azs         = ["us-east-1a", "us-east-1b","us-east-1c"  ]
pub_cidr_subnet  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
```
In the example above we described how many public subnets in one resource block, with what cidr range and which avalability zone it needs to be created. We combined element function with lenght function, which allowed us to loop inside of the given list and create 3 public subnets. By doing that we quite shortened our code made it even more reusable. You can also combine element function with lookup, lenght and index function, all depending how you want to retrive the item:

- When we use element function we can combine it with index which finds a particular value from a list.
- In case if use length it controls the length of a given list, map, or string.
- And lookup retrieves the value of a single element from a map, given its key. If the given key does not exist, the given default value is returned instead.

### "count" meta-argument

Count is a meta-argument is a very helpful when it comes to managing several similar objects without writing a separate block for it. Terraform has two ways of doing it by using count and for_each, basically what it does is it loops as many times as it given in count, usually it accepts a whole numbers.
Count value has to be known before terraform performs any actions. In our example above we combined count meta-argument, index, element, lenght functions. 

### "for_each" meta-argument

The second option of creating the similar resources with one block is to use for_each meta-argument. In the example below we used locals for describing details for our subnets and for_each for looping and creating 3 subnets with those items.
```
# Public Subnets

resource "aws_subnet" "public_subnet_" {
  for_each          = local.public_subnet
  vpc_id            = aws_vpc.my_vpc.id
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_pub_sub_${each.key}"
    }
  )
}

# Locals for public subnet

locals {
  public_subnet = {
    1 = { availability_zone = "us-east-1a", cidr_block = "10.0.1.0/24" },
    2 = { availability_zone = "us-east-1b", cidr_block = "10.0.2.0/24" },
    3 = { availability_zone = "us-east-1c", cidr_block = "10.0.3.0/24" }
  }
}
```

### Notes

- Terraform block for backend file has to be hardcoded, you can not use variables.
- Whenever you configure key in terraform block terraform tells you to run ```terraform init``` to reinitialize your backend file.
- A resource or module block cannot use both count and for_each.