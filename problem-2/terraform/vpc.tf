resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr-block
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "internet" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = var.subnet-cidr-block
  map_public_ip_on_launch = true
}
