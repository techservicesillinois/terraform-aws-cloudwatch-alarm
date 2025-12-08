locals {
  # Lambda alarm format strings.

  alarm_description_fmt = "%s lambda is exiting with errors"
  alarm_name_fmt        = "lambda-%s-%s"

  ##### FIXME: Is there a reason we do this, or is it just borrowing code not needed here?
  lambda_functions = (var.lambda_functions) != null ? var.lambda_functions : []

  # Parameters common to lambda alarms.

  alarm_common = {
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    key                 = "errors"
    metric_name         = "Errors"
    namespace           = "AWS/Lambda"
    period              = 300
    statistic           = "Maximum"
    threshold           = 1
  }

  # Data for lambda error alarms.

  error_alarms = {
    for function in toset(local.lambda_functions) :
    format("%s:%s", function, "errors") => {
      alarm_description = format(local.alarm_description_fmt, function)
      alarm_name        = format(local.alarm_name_fmt, function, "errors")
      function          = function
    }
  }
}

# Lambda function alarms.

resource "aws_cloudwatch_metric_alarm" "lambda" {
  for_each = local.error_alarms

  alarm_description   = each.value.alarm_description
  alarm_name          = each.value.alarm_name
  comparison_operator = local.alarm_common.comparison_operator
  evaluation_periods  = local.alarm_common.evaluation_periods
  metric_name         = local.alarm_common.metric_name
  namespace           = local.alarm_common.namespace
  period              = local.alarm_common.period
  statistic           = local.alarm_common.statistic
  threshold           = local.alarm_common.threshold

  dimensions = {
    "FunctionName" = each.value.function
    "Resource"     = each.value.function
  }

  # alarm_actions = [module.topic.topic_arns[0]]
  # ok_actions    = [module.topic.topic_arns[0]]
  tags = merge(var.tags, { Name = each.value.alarm_name })
}
