variable "lambda_functions" {
  description = "List of lambda functions for which alarms are created"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "(Optional) Tags to be applied to resources where supported"
  type        = map(string)
  default     = {}
}
