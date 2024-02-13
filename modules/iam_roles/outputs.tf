# This file outputs information from the iam_roles module that might be needed by other parts of our configuration, such as the ARNs of the IAM roles created for each Lambda function.

output "sechub_email_role_arn" {
  description = "The ARN of the IAM role for the sechub email Lambda function"
  value       = aws_iam_role.sechub_email.arn
}

output "sechub_dynamo_role_arn" {
  description = "The ARN of the IAM role for the sechub dynamodb Lambda function"
  value       = aws_iam_role.sechub_dynamo.arn
}

output "sechub_report_role_arn" {
  description = "The ARN of the IAM role for the sechub report Lambda function"
  value       = aws_iam_role.sechub_report.arn
}
