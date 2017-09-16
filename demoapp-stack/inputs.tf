// the number of EC2 instances to provision in the front-end cluster
variable "ec2-instance-count" {default = 1}

// Some additional EC2 settings
variable "ec2-volume-type" {default = "gp2"}
variable "ec2-volume-size" {default = "12"}
variable "ec2-instance-type" {default = "t2.micro"}
variable "ec2-ebs-optimized" {default = false}
variable "monitoring-enabled" {default = false}

// the ssh key to configure for instance access
variable "ssh-key-name" {}

// primarily used for tagging & naming of resources
variable "environment" {}

// the aws region
variable "region" {}

// the security groups from the VPC
variable "security-groups" {
  type = "map"
}

// the public subnets from the VPC
variable "public-subnets" {
  type = "list"
}

// the private subnets from the VPC
variable "private-subnets" {
  type = "list"
}

// the AMIs to be used
variable "ubuntu-amis" {
  type = "map"
}

