# VPC
resource "aws_vpc" "lms-projectb-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lms-projectb-vpc"
  }
}

# PUBLIC SUBNET
resource "aws_subnet" "lms-projectb-pub-subnet" {
  vpc_id     = aws_vpc.lms-projectb-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone_id = "ca-central-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "lms-projectb-pub-subnet"
  }
}

# PRIVATE SUBNET
resource "aws_subnet" "lms-projectb-priv-subnet" {
  vpc_id     = aws_vpc.lms-projectb-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone_id = "ca-central-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "lms-projectb-priv-subnet"
  }
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "lms-projectb-igw" {
  vpc_id = aws_vpc.lms-projectb-vpc.id

  tags = {
    Name = "lms-projectb-igw"
  }
}

# PUBLIC ROUTE TABLE
resource "aws_route_table" "lms-projectb-pub-rt" {
  vpc_id = aws_vpc.lms-projectb-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lms-projectb-igw.id
  }

  tags = {
    Name = "lms-projectb-pub-rt"
  }
}

# PUBLIC ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "lms-projectb-pub-rt-association" {
  subnet_id      = aws_subnet.lms-projectb-pub-subnet.id
  route_table_id = aws_route_table.lms-projectb-pub-rt.id
}

# PRIVATE ROUTE TABLE
resource "aws_route_table" "lms-projectb-priv-rt" {
  vpc_id = aws_vpc.lms-projectb-vpc.id

  tags = {
    Name = "lms-projectb-priv-rt"
  }
}

# PRIVATE ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "lms-projectb-priv-rt-association" {
  subnet_id      = aws_subnet.lms-projectb-priv-subnet.id
  route_table_id = aws_route_table.lms-projectb-priv-rt.id
}

# PUBLIC NACL
resource "aws_network_acl" "lms-projectb-pub-nacl" {
  vpc_id = aws_vpc.lms-projectb-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-projectb-pub-nacl"
  }
}