resource "aws_vpc" "game" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"

  tags = {
    Name = "game-vpc"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.game.id

  tags = {
    Name = "game-vpc-internet-gateway"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.game.default_route_table_id

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

resource "aws_main_route_table_association" "vpc_default" {
  route_table_id = aws_default_route_table.default.id
  vpc_id         = aws_vpc.game.id
}
