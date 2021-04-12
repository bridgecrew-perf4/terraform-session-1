resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_vpc
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env}-my_vpc"
    Environment = var.env
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pub_cidr1_subnet
  availability_zone = var.region_1a

  tags = {
    Name = "${var.env}-pub-sub-1"
  }
}
resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pub_cidr2_subnet
  availability_zone = var.region_1b
  tags = {
    Name = "${var.env}-pub-sub-2"
  }
}  

resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.priv_cidr1_subnet
  availability_zone = var.region_1a

  tags = {
    Name = "${var.env}-priv-sub-1"
  }
}
resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.priv_cidr2_subnet
  availability_zone = var.region_1b

  tags = {
    Name = "${var.env}-priv-sub-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.env}-igw"
    Environment = var.env 
  }
}

resource "aws_route_table" "pub_rtb" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
    tags = {
    Name = "${var.env}-pub_rtb"
    Environment = var.env 
  }
}

resource "aws_route_table_association" "pub_sub1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.pub_rtb.id
}
resource "aws_route_table_association" "pub_sub2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.pub_rtb.id
}

resource "aws_eip" "nat-gw-eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat-gw-eip.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "${var.env}-nat_gw"
    Environment = var.env 
  }
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
    tags = {
    Name = "${var.env}-private_rtb"
    Environment = var.env 
  }
}

resource "aws_route_table_association" "priv_sub1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private_rtb.id
}
resource "aws_route_table_association" "priv_sub2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private_rtb.id
}