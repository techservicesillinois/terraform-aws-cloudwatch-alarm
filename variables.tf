variable "ecs_cluster" {
  type        = string
  description = "ECS cluster containing services for which alarms are created"
  default     = null
}

variable "ecs_services" {
  description = "Map of ECS services for which alarms are created; key is name of service and value is an object with the attributes `cpu` and `memory`"
  type        = map(object({ cpu = number, memory = number }))
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
