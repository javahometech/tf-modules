# Create vpc for our application
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.vpc_tenancy

  tags = {
    Name        = "myapp-vpc"
    Environment = terraform.workspace
  }
}

# create private subnets
resource "aws_subnet" "private" {
  count             = local.az_length
  vpc_id            = aws_vpc.main.id
  availability_zone = local.az_names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)

  tags = {
    Name = "Private-${count.index + 1}-${terraform.workspace}"
  }
}

# create public subnets
resource "aws_subnet" "public" {
  count             = local.az_length
  vpc_id            = aws_vpc.main.id
  availability_zone = local.az_names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + local.az_length)

  tags = {
    Name = "Public-${count.index + 1}-${terraform.workspace}"
  }
}

# Create Internet Gateway for public subnets
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "myapp"
  }
}

# Create route table for public subnet

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-${terraform.workspace}"
  }
}

# attach public subnets with public route tables

resource "aws_route_table_association" "a" {
  count          = local.pub_sub_length
  subnet_id      = local.pub_sub_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# Create route table for private subnet

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat.id
  }

  tags = {
    Name = "private-${terraform.workspace}"
  }
}

resource "aws_route_table_association" "b" {
  count          = local.pub_sub_length
  subnet_id      = local.pri_sub_ids[count.index]
  route_table_id = aws_route_table.private.id
}

# NAT instance

# Create NAT instance in public subnet
resource "aws_instance" "nat" {
  ami                         = lookup(var.nat_amis, var.region)
  instance_type               = "t2.micro"
  subnet_id                   = local.pub_sub_ids[0]
  associate_public_ip_address = true
  source_dest_check           = false
  vpc_security_group_ids      = [aws_security_group.nat.id]
  key_name                    = "hari2020"
  tags = {
    "Name" = "Nat Instance"
  }
}

# Security Group for NAT instance

resource "aws_security_group" "nat" {
  name        = "nat-rules"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nat-instance-security-group"
  }
}
