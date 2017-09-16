provider "aws" {
  region                  = "${var.aws-region}"
  shared_credentials_file = "${var.aws-credentials-file}"
  profile                 = "${var.aws-credentials-profile}"
}
