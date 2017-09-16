resource "aws_instance" "demoapp" {
  count                     = "${var.ec2-instance-count}"
  ami                       = "${lookup(var.ubuntu-amis, var.region)}"
  instance_type             = "${var.ec2-instance-type}"
  ebs_optimized             = "${var.ec2-ebs-optimized}"
  monitoring                = "${var.monitoring-enabled}"
  key_name                  = "${var.ssh-key-name}"
  disable_api_termination   = false
  subnet_id                 = "${element(var.public-subnets, count.index)}"
  vpc_security_group_ids    = ["${lookup(var.security-groups, "fe-appservers")}"]
  root_block_device {
    delete_on_termination = true
    volume_type           = "${var.ec2-volume-type}"
    volume_size           = "${var.ec2-volume-size}"
  }
  volume_tags {
    "Name" = "${var.environment}-demoapp-${count.index}"
  }
  tags {
    "Name"        = "${var.environment}-demoapp-${count.index}"
    "Environment" = "${var.environment}"
    "Apps"        = "demoapp"
  }
}
