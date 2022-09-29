resource "aws_vpc" "gitlab-vpc" {
  cidr_block           = var.aws_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "gitlab-subnet" {
  availability_zone = var.aws_availability_zone
  cidr_block        = var.aws_subnet_cidr_block
  vpc_id            = aws_vpc.gitlab-vpc.id
}

resource "aws_security_group" "gitlab-sg" {
  name   = "gitlab-sg"
  vpc_id = aws_vpc.gitlab-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.gitlab-vpc.id
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.gitlab-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }
}

resource "aws_route_table_association" "subnet-association" {
  provider = aws

  subnet_id      = aws_subnet.gitlab-subnet.id
  route_table_id = aws_route_table.route-table.id
}