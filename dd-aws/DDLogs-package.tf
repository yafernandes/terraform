data "http" "lambda_function" {
  url = "https://raw.githubusercontent.com/DataDog/datadog-serverless-functions/master/aws/logs_monitoring/lambda_function.py"
}

data "archive_file" "DDlogs-package" {
  type        = "zip"
  output_path = "DDLogs-package.zip"
  source {
    content  = data.http.lambda_function.body
    filename = "lambda_function.py"
  }
}

