## provides subnet IDs in a way that can be dynamically looked-up by other modules
output "public_subnets" {
  value = {
    "a" = "${aws_subnet.public-a.id}"
    "b" = "${aws_subnet.public-b.id}"
    "c" = "${aws_subnet.public-c.id}"
  }
}

## provides subnet IDs in a way that can be dynamically looked-up by other modules
output "private_subnets" {
  value = {
    "a" = "${aws_subnet.private-a.id}"
    "b" = "${aws_subnet.private-b.id}"
    "c" = "${aws_subnet.private-c.id}"
  }
}

## provide security group IDs in a way that can be dynamically looked-up by other modules
output "security_groups" {
  value = {
    "public-lbs"   = "${aws_security_group.public-lbs.id}"
    "internal-lbs"   = "${aws_security_group.internal-lbs.id}"
    "fe-appservers" = "${aws_security_group.fe-appservers.id}"
    "be-appservers" = "${aws_security_group.be-appservers.id}"
  }
}
