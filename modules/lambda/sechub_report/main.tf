resource "aws_lambda_function" "sechub_report" {
  function_name    = var.function_name
  handler          = var.handler
  role             = var.lambda_role_arn
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout
  filename         = var.lambda_file_path
  source_code_hash = filebase64sha256(var.lambda_file_path)

  tags = var.tags

  environment {
    variables = {
      REPORT_BUCKET = var.s3_bucket_name   # This variable has to be passed to the module
    }
  }
}

resource "aws_cloudwatch_event_rule" "sechub_report_trigger" {
  name                = "${var.function_name}_trigger"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "sechub_report" {
  rule      = aws_cloudwatch_event_rule.sechub_report_trigger.name
  arn       = aws_lambda_function.sechub_report.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_sechub_report" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sechub_report.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sechub_report_trigger.arn
}
