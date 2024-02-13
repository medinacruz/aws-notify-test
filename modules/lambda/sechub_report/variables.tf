variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the s3 bucket where reports are stores"
  type        = string
}

variable "lambda_role_arn" {
  description = "The ARN of the IAM role for the Lambda function"
  type        = string
}

variable "lambda_file_path" {
  description = "Path to the ZIP file containing the Lambda function's code"
  type = string
}

variable "runtime" {
  description = "The runtime environment for the Lambda function"
  default = "python3.12"
  type = string
}

variable "handler" {
  description = "The handler method that processes the Lambda code"
  default = "lambda_function.lambda_handler"
  type = string
}

variable "memory_size" {
  description = "The amount of memory in MB that the Lambda function has access to"
  default = 1024
  type = number
}

variable "timeout" {
  description = "The amount of time the Lambda function has to run in seconds"
  default = 300 # 5 minutes
  type = number
}

variable "schedule_expression" {
  description = "The schedule expression for when the Lambda function will be triggered"
  default     = "cron(0 18 ? * SUN *)" # 12 PM CST, considering UTC time
  type = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
