# Define outputs for the module which can be used with other parts of the Terraform configuration.

output "sechub_email_lambda_arn" {
  description = "The ARN of the SecHubEmail Lambda function"
  value       = aws_lambda_function.sechub_email.arn
}

output "sechub_email_cloudwatch_event_rule_arn" {
  description = "The ARN of the CloudWatch Event Rule that triggers the SecHubEmail Lambda function"
  value       = aws_cloudwatch_event_rule.sechub_email_trigger.arn
}
