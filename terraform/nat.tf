########################
# NAT Gateway + EIP
########################
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}

########################
# Egress-Only Internet Gateway für IPv6 private Subnets
########################
resource "aws_egress_only_internet_gateway" "eogw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "private-eogw" }
}

########################
# Private Route Table (IPv4 + IPv6)
########################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # IPv4 via NAT
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  # IPv6 via Egress-Only GW
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.eogw.id
  }

  tags = { Name = "private-rt" }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b_assoc" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}
