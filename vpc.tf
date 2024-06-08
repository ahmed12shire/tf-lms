# VPC
resource "aws_vpc" "lms-projectb-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lms-projectb-vpc"
  }
}

# PUBLICE SUBNET
resource "aws_subnet" "lms-projectb-pub-subnet" {
  vpc_id     = aws_vpc.lms-projectb-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone_id = "ca-central-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "lms-projectb-pub-subnet"
  }
}