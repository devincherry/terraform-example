// Setup an SSH keypair for use in provisioned resources
resource "aws_key_pair" "admin" {
  key_name   = "${var.ssh-key-name}"
  public_key = "${var.ssh-pubkey}"
}
