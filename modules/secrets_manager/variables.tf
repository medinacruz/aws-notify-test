variable "secret_name" {
  description = "The name for the SMTP credentials secret in AWS Secrets Manager."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the secret in AWS Secrets Manager."
  type        = map(string)
  default     = {}
}
