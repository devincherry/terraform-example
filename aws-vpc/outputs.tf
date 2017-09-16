## provides subnet IDs in a way that can be dynamically looked-up by other modules
output "public-subnets" {
  value = ["${aws_subnet.public-a.*.id}", "${aws_subnet.public-b.*.id}", "${aws_subnet.public-c.*.id}"]
}

## provides subnet IDs in a way that can be dynamically looked-up by other modules
output "private-subnets" {
  value = ["${aws_subnet.private-a.*.id}", "${aws_subnet.private-b.*.id}", "${aws_subnet.private-c.*.id}"]
}

## provide security group IDs in a way that can be dynamically looked-up by other modules
output "security-groups" {
  value = {
    "public-lbs"   = "${aws_security_group.public-lbs.id}"
    "internal-lbs"   = "${aws_security_group.internal-lbs.id}"
    "fe-appservers" = "${aws_security_group.fe-appservers.id}"
    "be-appservers" = "${aws_security_group.be-appservers.id}"
  }
}
