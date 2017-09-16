resource "aws_elb" "public-demoapp" {
  name               = "${var.environment}-public-demoapp"
  subnets            = ["${var.public-subnets}"]
  internal           = false

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
    target              = "HTTP:80/"
    interval            = 20
  }

  instances                   = ["${aws_instance.demoapp.*.id}"]
  idle_timeout                = 60
  connection_draining         = false
  security_groups             = ["${lookup(var.security-groups, "public-lbs")}"]

  tags {
    Name        = "${var.environment}-demoapp"
    Environment = "${var.environment}"
    Apps        = "demoapp"
  }
}
