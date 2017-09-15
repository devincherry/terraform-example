module "dev-vpc" {
  source                = "./aws-vpc"
  environment           = "dev"
  region                = "${var.aws-region}"
  ssh-key               = "${var.ssh-key-name}"
  vpc-cidr              = "172.16.0.0/20"
  private-subnet-a-cidr = "172.16.0.0/24"
  private-subnet-b-cidr = "172.16.1.0/24"
  private-subnet-c-cidr = "172.16.2.0/24"
  public-subnet-a-cidr  = "172.16.8.0/24"
  public-subnet-b-cidr  = "172.16.9.0/24"
  public-subnet-c-cidr  = "172.16.10.0/24"
}

/*
module "dev-demoapp" {
  source            = "./demoapp"
  environment       = "dev"
  public_subnets    = "${module.dev-vpc.public_subnets}"
  private_subnets   = "${module.dev-vpc.private_subnets}"
  security_groups   = "${module.dev-vpc.security_groups}"
}
*/

