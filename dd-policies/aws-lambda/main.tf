provider "aws" {
  region                  = "us-west-1"
  shared_credentials_file = "/Users/alex.fernandes/.aws/credentials"
  profile                 = "default"
}

resource "aws_iam_role" "dd_lambda" {
  name = "alexf_lambda"

  assume_role_policy = "${file("trust-lambda.json")}"

  tags = {
    Creator = "alex.fernandes"
  }
}

resource "aws_iam_policy" "dd_lambda" {
  name   = "alexf_lambda"
  policy = "${file("policy-lambda.json")}"
}

resource "aws_iam_role_policy_attachment" "dd_lambda" {
  role       = "${aws_iam_role.dd_lambda.name}"
  policy_arn = "${aws_iam_policy.dd_lambda.arn}"
}

# https://docs.aws.amazon.com/lambda/latest/dg/enabling-x-ray.html
resource "aws_iam_role_policy_attachment" "AWSXrayWriteOnlyAccess" {
  role       = "${aws_iam_role.dd_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}
