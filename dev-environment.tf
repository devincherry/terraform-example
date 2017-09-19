// Provision the VPC
module "dev-vpc" {
  source                = "./aws-vpc"
  environment           = "dev"
  region                = "${var.aws-region}"
  ssh-key-name          = "${var.ssh-key-name}"
  ssh-pubkey            = "${var.ssh-pubkey}"
  vpc-cidr              = "172.16.0.0/20"
  admin-ip              = "${var.my-ip}"
  enable-be-nat         = false
  number-of-azs         = 1
  private-subnet-a-cidr = "172.16.0.0/24"
  private-subnet-b-cidr = "172.16.1.0/24"
  private-subnet-c-cidr = "172.16.2.0/24"
  public-subnet-a-cidr  = "172.16.8.0/24"
  public-subnet-b-cidr  = "172.16.9.0/24"
  public-subnet-c-cidr  = "172.16.10.0/24"
}

// Provision the dev DNS subdomain
resource "aws_route53_zone" "dev-mgmt-domain" {
  name = "dev.yarnixia.net."
}

// Setup NS records in top domain that point to subdomain's nameservers
resource "aws_route53_record" "dev-ns" {
  zone_id = "${aws_route53_zone.mgmt-domain.zone_id}"
  name    = "${aws_route53_zone.dev-mgmt-domain.name}"
  type    = "NS"
  ttl     = "30"

  records = ["${aws_route53_zone.dev-mgmt-domain.name_servers}"]
}

// Provision the management hosts (ssh-proxy, etc...)
module "dev-mgmt-stack" {
  source                = "./mgmt-stack"
  environment           = "dev"
  region                = "${var.aws-region}"
  ssh-key-name          = "${var.ssh-key-name}"
  public-subnets        = "${module.dev-vpc.public-subnets}"
  private-subnets       = "${module.dev-vpc.private-subnets}"
  security-groups       = "${module.dev-vpc.security-groups}"
  ubuntu-amis           = "${var.ubuntu1604-hvm-gp2-amis}"
  dns-zone-id           = "${aws_route53_zone.dev-mgmt-domain.id}"
  dns-zone-name         = "${aws_route53_zone.dev-mgmt-domain.name}"
}

module "dev-demoapp-stack" {
  source                = "./demoapp-stack"
  environment           = "dev"
  region                = "${var.aws-region}"
  ssh-key-name          = "${var.ssh-key-name}"
  public-subnets        = "${module.dev-vpc.public-subnets}"
  private-subnets       = "${module.dev-vpc.private-subnets}"
  security-groups       = "${module.dev-vpc.security-groups}"
  ubuntu-amis           = "${var.ubuntu1604-hvm-gp2-amis}"
//  dns-zone-id           = "${aws_route53_zone.dev-mgmt-domain.id}"
//  dns-zone-name         = "${aws_route53_zone.dev-mgmt-domain.name}"
}

