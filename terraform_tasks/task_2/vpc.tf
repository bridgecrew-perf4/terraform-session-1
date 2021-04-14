resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.is_enabled_dns_support
  enable_dns_hostnames = var.is_enabled_dns_hostnames

  tags = {
    Name        = "${var.env}-vpc"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pub_cidr1_subnet
  availability_zone = var.aws_az_1a

  tags = {
    Name        = "${var.env}-pub_sub1"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pub_cidr2_subnet
  availability_zone = var.aws_az_1b

  tags = {
    Name        = "${var.env}-pub_sub2"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pub_cidr3_subnet
  availability_zone = var.aws_az_1c

  tags = {
    Name        = "${var.env}-pub_sub3"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.priv_cidr1_subnet
  availability_zone = var.aws_az_1a

  tags = {
    Name        = "${var.env}-priv_sub1"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.priv_cidr2_subnet
  availability_zone = var.aws_az_1b

  tags = {
    Name        = "${var.env}-priv_sub2"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.priv_cidr3_subnet
  availability_zone = var.aws_az_1c

  tags = {
    Name        = "${var.env}-priv_sub3"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name        = "${var.env}-igw"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_route_table" "pub_rtb" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.env}-pub_rtb"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_route_table_association" "pub_sub1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.pub_rtb.id
}

resource "aws_route_table_association" "pub_sub2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.pub_rtb.id
}

resource "aws_route_table_association" "pub_sub3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.pub_rtb.id
}

resource "aws_eip" "nat-gw-eip" {
  vpc = true

  tags = {
    Name        = "${var.env}-eip"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat-gw-eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name        = "${var.env}-nat_gw"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name        = "${var.env}-private_rtb"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_route_table_association" "priv_sub1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "priv_sub2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "priv_sub3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_rtb.id
}