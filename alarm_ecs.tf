locals {
  # ECS alarm format strings.

  alarm_description_fmt = "%s ECS %s exceeds threshold (%d%%)"
  alarm_name_fmt        = "ecs-%s-%s"

  ecs_services = (var.ecs_services) != null ? var.ecs_services : {}

  # Parameters common to ECS alarms.

  alarm_common = {
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 3
    namespace           = "AWS/ECS"
    period              = 300
    statistic           = "Average"
  }

  # Data for ECS CPU alarms.

  ecs_cpu_alarms = {
    for service in keys(local.ecs_services) :
    format("%s:%s", service, "cpu") => {
      key         = "cpu"
      metric_name = "CPUUtilization"
      alarm_name  = format(local.alarm_name_fmt, service, "cpu")
      service     = service
      threshold   = local.ecs_services[service].cpu
    }
  }

  # Data for ECS memory alarms.

  ecs_memory_alarms = {
    for service in keys(local.ecs_services) :
    format("%s:%s", service, "memory") => {
      key         = "memory"
      metric_name = "MemoryUtilization"
      alarm_name  = format(local.alarm_name_fmt, service, "memory")
      service     = service
      threshold   = local.ecs_services[service].memory
    }
  }
}

# ECS service alarms.

resource "aws_cloudwatch_metric_alarm" "ecs_services" {
  for_each = merge(local.ecs_cpu_alarms, local.ecs_memory_alarms)

  alarm_description   = format(local.alarm_description_fmt, each.value.service, each.value.key, each.value.threshold)
  alarm_name          = each.value.alarm_name
  comparison_operator = local.alarm_common.comparison_operator
  evaluation_periods  = local.alarm_common.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = local.alarm_common.namespace
  period              = local.alarm_common.period
  statistic           = local.alarm_common.statistic
  threshold           = each.value.threshold

  dimensions = {
    ClusterName = var.ecs_cluster
    ServiceName = each.value.service
  }

  alarm_actions = [module.topic.topic_arns[0]]
  ok_actions    = [module.topic.topic_arns[0]]
  tags          = merge(var.tags, { Name = each.value.alarm_name })
}
