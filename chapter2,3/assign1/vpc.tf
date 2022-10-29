provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "willamettevpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "t101-study"
  }
}

resource "aws_subnet" "willamettesubnet1" {
  vpc_id     = aws_vpc.willamettevpc.id
  cidr_block = "10.10.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "t101-subnet1"
  }
}

resource "aws_subnet" "willamettesubnet2" {
  vpc_id     = aws_vpc.willamettevpc.id
  cidr_block = "10.10.2.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "t101-subnet2"
  }
}

resource "aws_internet_gateway" "willametteigw" {
  vpc_id = aws_vpc.willamettevpc.id

  tags = {
    Name = "t101-igw"
  }
}

resource "aws_route_table" "willamettert" {
  vpc_id = aws_vpc.willamettevpc.id

  tags = {
    Name = "t101-rt"
  }
}

resource "aws_route_table_association" "willametteassoc1" {
  subnet_id      = aws_subnet.willamettesubnet1.id
  route_table_id = aws_route_table.willamettert.id
}

resource "aws_route_table_association" "willametteassoc2" {
  subnet_id      = aws_subnet.willamettesubnet2.id
  route_table_id = aws_route_table.willamettert.id
}

resource "aws_route" "willametteroute" {
  route_table_id         = aws_route_table.willamettert.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.willametteigw.id
}
