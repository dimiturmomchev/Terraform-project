#-VPC-##########################################################################################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = var.name }
}

# Default Security Group for VPC
resource "aws_security_group" "default" {
  name        = "${var.name}-default-sg"
  description = "Default SG to allow traffic from the VPC"
  vpc_id      = aws_vpc.main.id
  depends_on  = [ aws_vpc.main]
  
  ingress { #Inbound rules
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress { #Outbound rules
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  tags = { Name = var.name }
}

#-Public-subnet-################################################################################
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags                    = { Name = "public-${var.name}" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.name}-public-route-table" }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
#-Gateways-#####################################################################################
# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.name}-igw" }
}
# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  depends_on             = [aws_route_table.public]
}
# Elastic-IP for NAT
resource "aws_eip" "this" {
  vpc        = true
  depends_on = [aws_internet_gateway.this]
}
# NAT
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public.id
  tags = { Name = var.name }
  depends_on    = [aws_internet_gateway.this]
}
# Route for NAT
resource "aws_route" "private_nat_gateway" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.this
}
#-Private-subnet-1-################################################################################
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false
  tags                    = { Name = "private-${var.name}" }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.name}-private-route-table" }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
  # gateway_id     = aws_nat_gateway.this.id
}
#-Private-subnet-2-################################################################################
resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_block_2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = false
  tags                    = { Name = "private-2-${var.name}" }
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.name}-private-2-route-table" }
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
  # gateway_id     = aws_nat_gateway.this.id
}