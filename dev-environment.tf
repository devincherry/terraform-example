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

module "dev-demoapp" {
  source                = "./demoapp-stack"
  environment           = "dev"
  region                = "${var.aws-region}"
  ssh-key-name          = "${var.ssh-key-name}"
  public-subnets        = "${module.dev-vpc.public-subnets}"
  private-subnets       = "${module.dev-vpc.private-subnets}"
  security-groups       = "${module.dev-vpc.security-groups}"
  ubuntu-amis           = "${var.ubuntu1604-hvm-gp2-amis}"
}
