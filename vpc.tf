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

# PUBLIC NACL ASSOCIATION
resource "aws_network_acl_association" "lms-projectb-pub-nacl-association" {
  network_acl_id = aws_network_acl.lms-projectb-pub-nacl.id
  subnet_id      = aws_subnet.lms-projectb-pub-subnet.id
}

# PRIVATE NACL
resource "aws_network_acl" "lms-projectb-priv-nacl" {
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
    Name = "lms-projectb-priv-nacl"
  }
}

# PRIVATE NACL ASSOCIATION
resource "aws_network_acl_association" "lms-projectb-priv-nacl-association" {
  network_acl_id = aws_network_acl.lms-projectb-priv-nacl.id
  subnet_id      = aws_subnet.lms-projectb-priv-subnet.id
}

# PUBLIC SECURITY GROUP
resource "aws_security_group" "lms-projectb-pub-sg" {
  name        = "lms-projectb-pub-server-sg"
  description = "Allow web server traffic"
  vpc_id      = aws_vpc.lms-projectb-vpc.id

  tags = {
    Name = "lms-projectb-pub-sg"
  }
}

# SSH TRAFFIC
resource "aws_vpc_security_group_ingress_rule" "lms-projectb-pub-ssh" {
  security_group_id = aws_security_group.lms-projectb-pub-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# HTTP TRAFFIC
resource "aws_vpc_security_group_ingress_rule" "lms-projectb-pub-http" {
  security_group_id = aws_security_group.lms-projectb-pub-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# 8080 TRAFFIC
resource "aws_vpc_security_group_ingress_rule" "lms-projectb-pub-8080" {
  security_group_id = aws_security_group.lms-projectb-pub-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

# 9000 TRAFFIC
resource "aws_vpc_security_group_ingress_rule" "lms-projectb-pub-9000" {
  security_group_id = aws_security_group.lms-projectb-pub-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 9000
  ip_protocol       = "tcp"
  to_port           = 9000
}

#  OUTBOUND TRAFFIC
resource "aws_vpc_security_group_egress_rule" "lms-projectb-pub-outbound" {
  security_group_id = aws_security_group.lms-projectb-pub-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
}