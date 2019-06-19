provider "aws" {
  region                  = "us-west-1"
  shared_credentials_file = "/Users/alex.fernandes/.aws/credentials"
  profile                 = "default"
}

data "aws_lambda_function" "dd_lambda_logs" {
  function_name = "${var.dd_lambda_forwarder_arn}"
}

data "aws_arn" "dd_lambda_logs" {
  arn = "${data.aws_lambda_function.dd_lambda_logs.role}"
}

data "aws_iam_role" "dd_lambda_logs" {
  name = "${element(split("/", data.aws_arn.dd_lambda_logs.resource), 1)}"
}

resource "aws_iam_policy" "dd_lambda_logs" {
  name   = "alexf_lambda_logs"
  policy = "${file("policy-lambda-logs.json")}"
}

resource "aws_iam_role_policy_attachment" "dd_lambda_logs" {
  role       = "${data.aws_iam_role.dd_lambda_logs.id}"
  policy_arn = "${aws_iam_policy.dd_lambda_logs.arn}"
}
