resource "aws_route53_record" "sshgw-dns" {
  zone_id = "${var.dns-zone-id}"
  name    = "sshgw.${var.dns-zone-name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.sshgw.public_ip}"]
}
