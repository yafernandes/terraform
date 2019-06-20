provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/alex.fernandes/.aws/credentials"
  profile                 = "default"
}

resource "aws_acm_certificate" "cert" {
  private_key      = "${var.private_key}"
  certificate_body = "${var.cert}"

  tags = {
    Name = "pipsquack.ca"
    Creator = "alex.fernandes"
  }
}
