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

resource "aws_iam_policy" "dd_lambda" {
  name   = "alexf_lambda"
  policy = "${file("policy-lambda.json")}"
}
resource "aws_iam_role_policy_attachment" "dd_lambda" {
  role       = "${aws_iam_role.dd_role.name}"
  policy_arn = "${aws_iam_policy.dd_lambda.arn}"
}
resource "aws_iam_policy" "dd_aws" {
  name   = "alexf_aws"
  policy = "${file("policy-aws.json")}"
}
resource "aws_iam_role_policy_attachment" "dd_aws" {
  role       = "${aws_iam_role.dd_role.name}"
  policy_arn = "${aws_iam_policy.dd_aws.arn}"
}

