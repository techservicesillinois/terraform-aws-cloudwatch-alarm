module "topic" {
  source = "github.com/techservicesillinois/terraform-aws-sns//modules/topic?ref=v3.1.1"

  tags   = var.tags
  topics = [format("%s-topic", var.name)]
}

locals {
  subscriptions = {
    format("%s-topic", var.name) = [
      for sub in var.subscriptions :
      {
        endpoint = sub.endpoint
        protocol = sub.protocol
      }
    ]
  }
}

module "subscription" {
  source = "github.com/techservicesillinois/terraform-aws-sns//modules/subscription?ref=v3.1.1"

  # Explicit 'depends_on' is required because subscriptions module
  # arguments are topic names instead of topic ARNs.
  depends_on = [module.topic]

  subscriptions = local.subscriptions
  # NOTE: Tags are not supported by this resource.
}
