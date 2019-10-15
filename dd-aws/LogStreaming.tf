resource "aws_kinesis_stream" "LogStreaming" {
  name             = "LogStreaming"
  shard_count      = 1
  retention_period = 24
  tags = {
    Creator = "alex.fernandes"
  }
}

resource "aws_iam_role" "LogStreaming" {
  name               = "LogStreaming"
  assume_role_policy = file("LogStreaming-role.json")
  tags = {
    Creator = "alex.fernandes"
  }
}

resource "aws_iam_policy" "LogStreaming" {
  name   = "LogStreaming"
  policy = file("LogStreaming-policy.json")
}

resource "aws_iam_role_policy_attachment" "LogStreaming" {
  role       = aws_iam_role.LogStreaming.name
  policy_arn = aws_iam_policy.LogStreaming.arn
}

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn  = "${aws_kinesis_stream.LogStreaming.arn}"
  function_name     = "${aws_lambda_function.DDLogs.arn}"
  starting_position = "LATEST"
  depends_on = [aws_iam_role_policy_attachment.AWSLambdaKinesisExecutionRole]
}

# resource "aws_cloudwatch_log_subscription_filter" "DDLogs" {
#   name            = "alexf-LogStreaming"
#   role_arn        = aws_iam_role.LogStreaming.arn
#   log_group_name  = "/aws/lambda/DDLogs"
#   filter_pattern  = ""
#   destination_arn = aws_kinesis_stream.LogStreaming.arn
# }

resource "aws_cloudwatch_log_subscription_filter" "alexf-dash" {
  name            = "alexf-LogStreaming"
  role_arn        = aws_iam_role.LogStreaming.arn
  log_group_name  = "/aws/lambda/alexf-dash"
  filter_pattern  = ""
  destination_arn = aws_kinesis_stream.LogStreaming.arn
}

resource "aws_cloudwatch_log_subscription_filter" "alex-end-of-line" {
  name            = "alexf-LogStreaming"
  role_arn        = aws_iam_role.LogStreaming.arn
  log_group_name  = "/aws/lambda/alex-end-of-line"
  filter_pattern  = ""
  destination_arn = aws_kinesis_stream.LogStreaming.arn
}

resource "aws_cloudwatch_log_subscription_filter" "API-Gateway-Execution-Logs_f0d7meg2zh_prod" {
  name            = "alexf-LogStreaming"
  role_arn        = aws_iam_role.LogStreaming.arn
  log_group_name  = "API-Gateway-Execution-Logs_f0d7meg2zh/prod"
  filter_pattern  = ""
  destination_arn = aws_kinesis_stream.LogStreaming.arn
}

