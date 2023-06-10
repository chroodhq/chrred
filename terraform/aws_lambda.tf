data "archive_file" "lambda_package" {
  type             = "zip"
  source_dir       = "${path.module}/package"
  output_path      = "${path.module}/output.zip"
  output_file_mode = "0644"
  excludes         = ["*.pyc"]
}

resource "aws_lambda_function" "monolith" {
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  function_name    = "${local.resource_prefix}-monolith"
  role             = aws_iam_role.lambda.arn
  handler          = "src/interfaces/lambda_function.lambda_handler"
  runtime          = "python3.10"
  timeout          = 5
  memory_size      = 128
  architectures    = ["arm64"]

  tracing_config {
    mode = "Active"
  }

  publish = true

  environment {
    variables = {
      LOG_LEVEL                    = "DEBUG"
      ENVIRONMENT                  = var.environment
      MATCHING_TABLE_DB_TABLE_NAME = aws_dynamodb_table.matching_table.name
      BASE_URL                     = local.domain
    }
  }
}

resource "aws_lambda_permission" "api_gateway_invocation" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:invokeFunction"
  function_name = aws_lambda_function.monolith.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.monolith.execution_arn}/*/*/*"
}
