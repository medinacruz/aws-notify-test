variable "bucket_name" {
  description = "The name of the S3 bucket for storing SecHub Reports"
  type        = string
}

variable "bucket_lifecycle_days" {
  description = "Number of days to keep the reports in the bucket before expiration"
  type        = number
  default     = 365
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
