provider "aws" {
  region = var.AWS_REGION
}

terraform {
  backend "s3" {}
}


########################
# VPC
########################
resource "aws_vpc" "main" {
  cidr_block                     = "10.0.0.0/16"
  enable_dns_support             = true
  enable_dns_hostnames           = true
  assign_generated_ipv6_cidr_block = true

  tags = { Name = "main-vpc" }
}

########################
# Public Subnets
########################
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  ipv6_cidr_block         = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 0)
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = { Name = "public-subnet" }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  ipv6_cidr_block         = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 1)
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = { Name = "public-subnet-b" }
}

########################
# Private Subnets
########################
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  ipv6_cidr_block   = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 2)
  availability_zone = "eu-central-1a"

  tags = { Name = "private-subnet" }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  ipv6_cidr_block   = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 3)
  availability_zone = "eu-central-1b"

  tags = { Name = "private-subnet-b" }
}

########################
# Internet Gateway
########################
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "main-gw" }
}

########################
# Public Route Table
########################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # IPv4 Default Route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  # IPv6 Default Route
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = { Name = "public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}
