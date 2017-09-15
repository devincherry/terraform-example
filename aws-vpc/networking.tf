resource "aws_vpc" "vpc" {
  cidr_block            = "${var.vpc-cidr}"
  enable_dns_hostnames  = true
  tags {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}-igw"
  }
}

resource "aws_eip" "nat-eip-a" {
  count = "${var.enable-be-nat ? 1 : 0}"
  vpc = true
}
resource "aws_eip" "nat-eip-b" {
  count = "${var.enable-be-nat && var.number-of-azs > 1 ? 1 : 0}"
  vpc = true
}
resource "aws_eip" "nat-eip-c" {
  count = "${var.enable-be-nat && var.number-of-azs > 2 ? 1 : 0}"
  vpc = true
}
resource "aws_nat_gateway" "nat-gateway-a" {
  count = "${var.enable-be-nat ? 1 : 0}"
  allocation_id = "${aws_eip.nat-eip-a.id}"
  subnet_id     = "${aws_subnet.public-a.id}"
}
resource "aws_nat_gateway" "nat-gateway-b" {
  count = "${var.enable-be-nat && var.number-of-azs > 1 ? 1 : 0}"
  allocation_id = "${aws_eip.nat-eip-b.id}"
  subnet_id     = "${aws_subnet.public-b.id}"
}
resource "aws_nat_gateway" "nat-gateway-c" {
  count = "${var.enable-be-nat && var.number-of-azs > 2 ? 1 : 0}"
  allocation_id = "${aws_eip.nat-eip-c.id}"
  subnet_id     = "${aws_subnet.public-c.id}"
}

/*** setup the public subnets ***/

resource "aws_subnet" "public-a" {
  vpc_id                    = "${aws_vpc.vpc.id}"
  availability_zone         = "${var.region}a"
  cidr_block                = "${var.public-subnet-a-cidr}"
  map_public_ip_on_launch   = true
  tags {
    Name = "${var.environment}-public-a"
  }
}
resource "aws_subnet" "public-b" {
  count = "${var.number-of-azs > 1 ? 1 : 0}"
  vpc_id                    = "${aws_vpc.vpc.id}"
  availability_zone         = "${var.region}b"
  cidr_block                = "${var.public-subnet-b-cidr}"
  map_public_ip_on_launch   = true
  tags {
    Name = "${var.environment}-public-b"
  }
}
resource "aws_subnet" "public-c" {
  count = "${var.number-of-azs > 2 ? 1 : 0}"
  vpc_id                    = "${aws_vpc.vpc.id}"
  availability_zone         = "${var.region}c"
  cidr_block                = "${var.public-subnet-c-cidr}"
  map_public_ip_on_launch   = true
  tags {
    Name = "${var.environment}-public-c"
  }
}


/*** setup the private subnets ***/

resource "aws_subnet" "private-a" {
  vpc_id                    = "${aws_vpc.vpc.id}"
  availability_zone         = "${var.region}a"
  cidr_block                = "${var.private-subnet-a-cidr}"
  map_public_ip_on_launch   = false
  tags {
    Name = "${var.environment}-private-a"
  }
}
resource "aws_subnet" "private-b" {
  count = "${var.number-of-azs > 1 ? 1 : 0}"
  vpc_id                    = "${aws_vpc.vpc.id}"
  availability_zone         = "${var.region}b"
  cidr_block                = "${var.private-subnet-b-cidr}"
  map_public_ip_on_launch   = false
  tags {
    Name = "${var.environment}-private-b"
  }
}
resource "aws_subnet" "private-c" {
  count = "${var.number-of-azs > 2 ? 1 : 0}"
  vpc_id                    = "${aws_vpc.vpc.id}"
  availability_zone         = "${var.region}c"
  cidr_block                = "${var.private-subnet-c-cidr}"
  map_public_ip_on_launch   = false
  tags {
    Name = "${var.environment}-private-c"
  }
}


/*** setup the public/dmz route table ***/

resource "aws_route_table" "public-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}-public-route-table"
  }
}
resource "aws_main_route_table_association" "public-route-table-main-assoc" {
  route_table_id = "${aws_route_table.public-route-table.id}"
  vpc_id = "${aws_vpc.vpc.id}"
}
resource "aws_route_table_association" "public-route-table-subnet-assoc-a" {
  route_table_id = "${aws_route_table.public-route-table.id}"
  subnet_id = "${aws_subnet.public-a.id}"
}
resource "aws_route_table_association" "public-route-table-subnet-assoc-b" {
  count = "${var.number-of-azs > 1 ? 1 : 0}"
  route_table_id = "${aws_route_table.public-route-table.id}"
  subnet_id = "${aws_subnet.public-b.id}"
}
resource "aws_route_table_association" "public-route-table-subnet-assoc-c" {
  count = "${var.number-of-azs > 2 ? 1 : 0}"
  route_table_id = "${aws_route_table.public-route-table.id}"
  subnet_id = "${aws_subnet.public-c.id}"
}
resource "aws_route" "public-route-default" {
  route_table_id            = "${aws_route_table.public-route-table.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = "${aws_internet_gateway.igw.id}"
}


/*** setup the private/internal route tables ***/

resource "aws_route_table" "private-route-table-a" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}-private-route-table-a"
  }
}
resource "aws_route_table" "private-route-table-b" {
  count = "${var.number-of-azs > 1 ? 1 : 0}"
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}-private-route-table-b"
  }
}
resource "aws_route_table" "private-route-table-c" {
  count = "${var.number-of-azs > 2 ? 1 : 0}"
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}-private-route-table-c"
  }
}
resource "aws_route_table_association" "private-route-table-subnet-assoc-a" {
  route_table_id = "${aws_route_table.private-route-table-a.id}"
  subnet_id = "${aws_subnet.private-a.id}"
}
resource "aws_route_table_association" "private-route-table-subnet-assoc-b" {
  count = "${var.number-of-azs > 1 ? 1 : 0}"
  route_table_id = "${aws_route_table.private-route-table-b.id}"
  subnet_id = "${aws_subnet.private-b.id}"
}
resource "aws_route_table_association" "private-route-table-subnet-assoc-c" {
  count = "${var.number-of-azs > 2 ? 1 : 0}"
  route_table_id = "${aws_route_table.private-route-table-c.id}"
  subnet_id = "${aws_subnet.private-c.id}"
}
resource "aws_route" "private-route-default-a" {
  count = "${var.enable-be-nat ? 1 : 0}"
  route_table_id            = "${aws_route_table.private-route-table-a.id}"
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = "${aws_nat_gateway.nat-gateway-a.id}"
}
resource "aws_route" "private-route-default-b" {
  count = "${var.enable-be-nat && var.number-of-azs > 1 ? 1 : 0}"
  route_table_id            = "${aws_route_table.private-route-table-b.id}"
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = "${aws_nat_gateway.nat-gateway-b.id}"
}
resource "aws_route" "private-route-default-c" {
  count = "${var.enable-be-nat && var.number-of-azs > 2 ? 1 : 0}"
  route_table_id            = "${aws_route_table.private-route-table-c.id}"
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = "${aws_nat_gateway.nat-gateway-c.id}"
}
