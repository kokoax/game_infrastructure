resource "aws_subnet" "_7dtd" {
  vpc_id                  = aws_vpc.game.id
  availability_zone       = "ap-northeast-1d"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    name = "7dtd-subnet-public"
  }
}

resource "aws_route_table_association" "_7dtd_public" {
  route_table_id = aws_default_route_table.default.id
  subnet_id      = aws_subnet._7dtd.id
}
