variable "ecs_cluster" {
  type        = string
  description = "ECS cluster containing services for which alarms are created"
}

variable "ecs_services" {
  type        = list(string)
  description = "List of ECS services for which alarms are created"
  default     = null
}

variable "name" {
  type        = string
  description = "Service name"
}

variable "subscriptions" {
  type        = list(map(string))
  description = "Subscriptions to alarm topic"
}

variable "tags" {
  description = "(Optional) Tags to be applied to resources where supported"
  type        = map(string)
  default     = {}
}
