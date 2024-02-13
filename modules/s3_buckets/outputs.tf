output "sechub_report_bucket_name" {
  description = "The name of the S3 bucket used for storing SecHub Reports"
  value       = aws_s3_bucket.sechub_report_bucket.bucket
}

output "sechub_report_bucket_arn" {
  description = "The ARN of the S3 bucket used for storing SecHub Reports"
  value       = aws_s3_bucket.sechub_report_bucket.arn
}
