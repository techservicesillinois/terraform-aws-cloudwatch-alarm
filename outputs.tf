output "metric_alarms" {
  value = [for alarm in aws_cloudwatch_metric_alarm.ecs_services : alarm.arn]
}

output "subscriptions" {
  value = [
    for s in var.subscriptions : format("%s:%s", s.protocol, s.endpoint)
  ]
}

output "topic" {
  value = module.topic.topic_arns[0]
}
