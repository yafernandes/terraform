provider "aws" {
  region                  = "us-west-1"
  shared_credentials_file = "/Users/alex.fernandes/.aws/credentials"
  profile                 = "default"
}

resource "aws_iam_role" "dd_role" {
  name = "alexf_dd-role"

  assume_role_policy = "${file("secret-datadog.json")}"

  tags = {
    Creator = "alex.fernandes"
  }
}

# https://docs.datadoghq.com/integrations/amazon_lambda/
resource "aws_iam_role_policy" "dd_lambda" {
  name   = "alexf_lambda"
  role   = "${aws_iam_role.dd_role.id}"
  policy = "${file("policy-lambda.json")}"
}

resource "aws_iam_role_policy" "dd_aws" {
  name   = "alexf_lambda"
  role   = "${aws_iam_role.dd_role.id}"
  policy = "${file("policy-aws.json")}"
}

