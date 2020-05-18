resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"

  tags = {
    Name = "7dtd-vpc"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "7dtd-vpc-internet-gateway"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    name = "7dtd-subnet-public"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }

  tags = {
    Name = "7dtd-vpc-route-table"
  }
}

resource "aws_main_route_table_association" "default" {
  route_table_id = aws_default_route_table.default.id
  vpc_id         = aws_vpc.vpc.id
}

resource "aws_route_table_association" "default_public" {
  route_table_id = aws_default_route_table.default.id
  subnet_id      = aws_subnet.public.id
}
