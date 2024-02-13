variable "function_name" {
  description = "The name of the Lambda function"
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
  default = "dotnet6"
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

variable "handler" {
  description = "The handler method that processes the Lambda code"
  default = "FunctionHandler"
  type = string
}
variable "schedule_expression" {
  description = "The schedule expression for when the Lambda function will be triggered"
  default     = "cron(0 10 ? * MON *)" # 4 AM CST, considering UTC time
  type = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table the Lambda function will interact with"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
