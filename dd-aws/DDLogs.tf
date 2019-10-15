resource "aws_iam_role" "DDLogs" {
  name = "DDLogs"

  assume_role_policy = file("DDLogs-role.json")

  tags = {
    Creator = "alex.fernandes"
  }
}

resource "aws_iam_policy" "DDLogs" {
  name   = "DDLogs"
  policy = file("DDLogs-policy.json")
}

resource "aws_iam_role_policy_attachment" "DDLogs" {
  role       = aws_iam_role.DDLogs.name
  policy_arn = aws_iam_policy.DDLogs.arn
}

# https://docs.aws.amazon.com/lambda/latest/dg/enabling-x-ray.html
resource "aws_iam_role_policy_attachment" "AWSXrayWriteOnlyAccess" {
  role       = aws_iam_role.DDLogs.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

# https://docs.aws.amazon.com/lambda/latest/dg/with-kinesis.html
resource "aws_iam_role_policy_attachment" "AWSLambdaKinesisExecutionRole" {
  role       = aws_iam_role.DDLogs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
}

resource "aws_lambda_function" "DDLogs" {
  function_name = "DDLogs"
  role          = aws_iam_role.DDLogs.arn
  handler       = "lambda_function.lambda_handler"

  filename         = "DDLogs-package.zip"
  source_code_hash = filebase64sha256("DDLogs-package.zip")

  memory_size = 1024
  timeout     = 120

  runtime = "python3.7"

  environment {
    variables = {
      DD_API_KEY = var.dd-api-key
    }
  }
  depends_on = [
    data.archive_file.DDlogs-package,
    aws_iam_role_policy_attachment.DDLogs,
    aws_iam_role_policy_attachment.AWSXrayWriteOnlyAccess
  ]
}

