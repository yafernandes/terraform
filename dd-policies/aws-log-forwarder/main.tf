provider "aws" {
  region                  = "us-west-1"
  shared_credentials_file = "/Users/alex.fernandes/.aws/credentials"
  profile                 = "default"
}

data "aws_lambda_function" "dd_log_forwarder" {
  function_name = "${var.dd_log_forwarder_arn}"
}

data "aws_arn" "dd_log_forwarder" {
  arn = "${data.aws_lambda_function.dd_log_forwarder.role}"
}

data "aws_iam_role" "dd_log_forwarder" {
  # name = "${split("/", data.aws_arn.dd_log_forwarder.resource)[1]}"
  name = "${replace(data.aws_arn.dd_log_forwarder.resource, "/.*\\//", "")}"
}

resource "aws_iam_policy" "dd_log_forwarder" {
  name   = "alexf_lambda_logs"
  policy = "${file("policy-log-forwarder.json")}"
}

resource "aws_iam_role_policy_attachment" "dd_log_forwarder" {
  role       = "${data.aws_iam_role.dd_log_forwarder.id}"
  policy_arn = "${aws_iam_policy.dd_log_forwarder.arn}"
}
