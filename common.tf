// Configure the aws provider
provider "aws" {
  region                  = "${var.aws-region}"
  shared_credentials_file = "${var.aws-credentials-file}"
  profile                 = "${var.aws-credentials-profile}"
}

// Create the top-level mgmt domain, used for all environments.
// (domain registration needs to be done as a separate step)
resource "aws_route53_zone" "mgmt-domain" {
  name = "yarnixia.net."
}

