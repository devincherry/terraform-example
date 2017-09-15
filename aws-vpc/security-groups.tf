resource "aws_security_group" "public-lbs" {
  name          = "${var.environment}-public-lbs"
  description   = "Publicly-accessible load-balancers"
  vpc_id        = "${aws_vpc.vpc.id}"
  tags {
    Name        = "${var.environment}-public-lbs"
  }

  // allow TCP from anywhere (subject to available listeners)
  ingress {
    from_port     = 0
    to_port       = 65535
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }
  // allow ping from VPC IP space
  ingress {
    from_port     = 8
    to_port       = -1
    protocol      = "icmp"
    cidr_blocks   = ["${var.vpc-cidr}"]
  }
}

resource "aws_security_group" "internal-lbs" {
  name          = "${var.environment}-internal-lbs"
  description   = "Internally-accessible load-balancers"
  vpc_id        = "${aws_vpc.vpc.id}"
  tags {
    Name        = "${var.environment}-internal-lbs"
  }

  // allow TCP from VPC IP space
  ingress {
    from_port     = 0
    to_port       = 65535
    protocol      = "tcp"
    cidr_blocks   = ["${var.vpc-cidr}"]
  }
  // allow ping from VPC IP space
  ingress {
    from_port     = 8
    to_port       = -1
    protocol      = "icmp"
    cidr_blocks   = ["${var.vpc-cidr}"]
  }
}

resource "aws_security_group" "fe-appservers" {
  name          = "${var.environment}-fe-appservers"
  description   = "Front-End Appservers"
  vpc_id        = "${aws_vpc.vpc.id}"
  tags {
    Name        = "${var.environment}-fe-appservers"
  }

  // allow all traffic from public LBs
  ingress {
    from_port     = 0
    to_port       = 65535
    protocol      = "tcp"
    security_groups = ["${aws_security_group.public-lbs.id}"]
  }
  // allow ping from VPC IP space
  ingress {
    from_port     = 8
    to_port       = -1
    protocol      = "icmp"
    cidr_blocks   = ["${var.vpc-cidr}"]
  }
}

resource "aws_security_group" "be-appservers" {
  name          = "${var.environment}-be-appservers"
  description   = "Back-End Appservers"
  vpc_id        = "${aws_vpc.vpc.id}"
  tags {
    Name        = "${var.environment}-be-appservers"
  }

  // allow all traffic from VPC back-end IP space (front-end access goes thru LBs)
  ingress {
    from_port     = 0
    to_port       = 65535
    protocol      = "tcp"
    cidr_blocks   = ["${compact(list(var.private-subnet-a-cidr, var.number-of-azs > 1 ? var.private-subnet-b-cidr : "", var.number-of-azs > 2 ? var.private-subnet-c-cidr : ""))}"]
  }
  // allow ping from VPC IP space
  ingress {
    from_port     = 8
    to_port       = -1
    protocol      = "icmp"
    cidr_blocks   = ["${var.vpc-cidr}"]
  }
}
