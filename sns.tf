resource "aws_sns_topic" "default" {
  name = "${var.name}-alarm"
}

#resource "aws_sns_topic" "ok" {
# name = "${var.name}-ok"
#}

resource "aws_sns_topic_subscription" "default" {
  count = length(var.subscriptions)

  topic_arn = aws_sns_topic.default.arn
  protocol  = var.subscriptions[count.index].protocol
  endpoint  = var.subscriptions[count.index].endpoint
}
