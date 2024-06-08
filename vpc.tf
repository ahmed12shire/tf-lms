# VPC
resource "aws_vpc" "lms-projectb-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lms-projectb-vpc"
  }
}