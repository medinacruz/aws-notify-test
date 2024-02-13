# Define outputs for the module which can be used with other parts of the Terraform configuration.

output "sechub_dynamo_lambda_arn" {
  description = "The ARN of the SecHubDynamo Lambda function"
  value       = aws_lambda_function.sechub_dynamo.arn
}

output "sechub_dynamo_cloudwatch_event_rule_arn" {
  description = "The ARN of the CloudWatch Event Rule that triggers the SecHubDynamo Lambda function"
  value       = aws_cloudwatch_event_rule.sechub_dynamo_trigger.arn
}
