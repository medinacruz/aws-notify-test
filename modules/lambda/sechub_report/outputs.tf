# Define outputs for the module which can be used with other parts of the Terraform configuration.

output "sechub_report_lambda_arn" {
  description = "The ARN of the SecHubReport Lambda function"
  value       = aws_lambda_function.sechub_report.arn
}

output "sechub_report_s3_bucket_name" {
  description = "The name of the s3 bucket for storing reports"
  value       = aws_s3_bucket.sechub_report_bucket.bucket
}

output "sechub_report_cloudwatch_event_rule_arn" {
  description = "The ARN of the CloudWatch Event Rule that triggers the SecHubReport Lambda function"
  value       = aws_cloudwatch_event_rule.sechub_report_trigger.arn
}
