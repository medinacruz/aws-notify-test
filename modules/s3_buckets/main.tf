resource "aws_s3_bucket" "sechub_report_bucket" {
  bucket = var.bucket_name

  versioning {
    enabled = true
  }
  lifecycle_rule {
    id      = "expire_old_objects"
    enabled = true

    expiration {
    days = var.bucket_lifecycle_days
    }
  }

  tags = var.tags
}
