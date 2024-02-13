output "aws_platform_lambda_sechub_alerts" {
  description = "The ARN of the SecHub Alerts lambda function"
  value       = module.aws_platform_lambda_sechub_alerts.lambda_arn
}

output "aws_platform_lambda_sechub_dynamo" {
  description = "The ARN of the SecHub DynamoDB lambda function"
  value       = module.aws_platform_lambda_sechub_dynamo.lambda_arn
}

output "aws_platform_lambda_sechub_report" {
  description = "The ARN of the SecHub Report lambda function"
  value       = module.aws_platform_lambda_sechub_report.lambda_arn
}

output "secret_manager_arn" {
  description = "The ARN of the secret stored in AWS Secret Manager"
  value       = module.secrets_manager.secret_arn
}
