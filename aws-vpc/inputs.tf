// The aws region
variable "region" {}

// The ssh-key name to use (used by aws_instances)
variable "ssh-key-name" {}
variable "ssh-pubkey" {}

// Creates a security group exception allowing this IP to SSH into public instances
variable "admin-ip" {default = "240.0.0.123"}

// The logical environment, used for naming & tagging mostly
variable "environment" {}

// The CIDR representation of the VPC's address space
variable "vpc-cidr" {}

// The number of AZs to provision (i.e. to have redundancy, use 2-3)
variable "number-of-azs" {default = 1}

// Whether or not to allow back-end subnets to egress to the internet via a NAT GW.
// A false value here means the backend servers can't egress to the internet at all.
// A true value here will spawn a NAT gateway in each back-end subnet.
// WARNING: NAT gateways have hourly costs!!! (currently about $30-35 per month, per GW)
variable "enable-be-nat" {default = false}

// The CIDR ranges for the individual subnets. First one is required, and you'll
// need to specify values for the others as-needed (i.e. when var.number-of-azs > 1).
variable "public-subnet-a-cidr" {}
variable "public-subnet-b-cidr" {default = "0.0.0.0/0"}
variable "public-subnet-c-cidr" {default = "0.0.0.0/0"}
variable "private-subnet-a-cidr" {}
variable "private-subnet-b-cidr" {default = "0.0.0.0/0"}
variable "private-subnet-c-cidr" {default = "0.0.0.0/0"}
