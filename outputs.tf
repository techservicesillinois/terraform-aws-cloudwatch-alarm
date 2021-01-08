output "alarm_arn" {
  value = [for alarm in aws_cloudwatch_metric_alarm.ecs_services : alarm.arn]
}

output "topic_arn" {
  value = aws_sns_topic.default.arn
}
