variable "account" {
  default = "919465544916"
}

variable "region" {
  default = "eu-east-1"
}

variable "project_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {
    Terraform   = "true"
    Environment = "PRD"
  }
}
