#This file defines any input variables the IAM module requires.  Might be useful to parametirize certain aspects if infra grows.

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
