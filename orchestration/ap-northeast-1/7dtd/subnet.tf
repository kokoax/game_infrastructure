resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "7dtd-vpc-internet-gateway"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1d"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    name = "7dtd-subnet-public"
  }
}

resource "aws_route_table_association" "default_public" {
  route_table_id = aws_default_route_table.default.id
  subnet_id      = aws_subnet.public.id
}
