 terraform {
  backend "s3" {}  #terragrunt khud backend manage kerta h iske jarurat nhi h 
}

###########################
# Provider
############################
# provider "aws" {
#   region = var.aws_region #terragrunt manage kere ga 
# }

############################
# VPC
############################
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

############################
# Internet Gateway
############################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }
}

############################
# Public Subnet
############################
resource "aws_subnet" "public" {
  for_each = toset(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = "${var.aws_region}${index(var.public_subnet_cidrs, each.value) == 0 ? "a" : "b"}"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${each.value}"
    Type = "public"
  }
}

############################
# Private Subnet
############################
resource "aws_subnet" "private" {
  for_each = toset(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = "${var.aws_region}${index(var.private_subnet_cidrs, each.value) == 0 ? "a" : "b"}"

  tags = {
    Name = "private-subnet-${each.value}"
    Type = "private"
  }
}
  


############################
# Public Route Table
############################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-public-rt"
  }
}

############################
# Private Route Table
############################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-private-rt"
  }
}

############################
# Route to Internet
############################
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

############################
# Associate Public Subnet
############################  
resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

############################
# Associate Private Subnet
############################  
resource "aws_route_table_association" "private_assoc" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}