// Create an SSH proxy host, allowing management access to AWS resources.
resource "aws_instance" "sshgw" {
  ami                       = "${lookup(var.ubuntu-amis, var.region)}"
  instance_type             = "${var.ec2-instance-type}"
  ebs_optimized             = "${var.ec2-ebs-optimized}"
  monitoring                = "${var.monitoring-enabled}"
  key_name                  = "${var.ssh-key-name}"
  disable_api_termination   = false
  subnet_id                 = "${element(var.public-subnets, 0)}"
  vpc_security_group_ids    = ["${lookup(var.security-groups, "sshgw-hosts")}"]
  root_block_device {
    delete_on_termination = true
    volume_type           = "${var.ec2-volume-type}"
    volume_size           = "${var.ec2-volume-size}"
  }
  volume_tags {
    "Name" = "${var.environment}-sshgw"
  }
  tags {
    "Name"        = "${var.environment}-sshgw"
    "Environment" = "${var.environment}"
  }
}
