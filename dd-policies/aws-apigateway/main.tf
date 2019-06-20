provider "aws" {
  region                  = "us-west-1"
  shared_credentials_file = "/Users/alex.fernandes/.aws/credentials"
  profile                 = "default"
}

resource "aws_iam_role" "cloudwatch" {
  name = "alexf_cloudwatch"

  assume_role_policy = "${file("trust-apigateway.json")}"
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "default"
  role = "${aws_iam_role.cloudwatch.id}"

  policy = "${file("policy-cloudwatch.json")}"
}


resource "aws_api_gateway_account" "sandbox" {
  cloudwatch_role_arn = "${aws_iam_role.cloudwatch.arn}"
}

