output "smtp_credentials_secret_arn" {
  description = "The ARN of the SMTP credentials secret container in AWS Secrets Manager"
  value       = aws_secrets_manager_secret.smtp_credentials.arn
}

output "smtp_credentials_secret_name" {
  description = "The name of the SMTP credentials secret container in AWS Secret Manager"
  value       = aws_secrets_manager_secret.smtp_credentials.name 
}

