# cloudwatch-alarm

[![Terraform actions status](https://github.com/techservicesillinois/terraform-aws-cloudwatch-alarm/workflows/terraform/badge.svg)](https://github.com/techservicesillinois/terraform-aws-cloudwatch-alarm/actions)

Provides CloudWatch alarms. This module's support is currently limited to ECS
services, and currently supports only the `CPUUtilization` and `MemoryUtilization`
metrics.

In this minimum viable implementation, the CloudWatch alarm period, and
statistic are hardcoded. Thresholds for the `CPUUtilization` and
`MemoryUtilization` metrics can be specified by the caller; both values are numeric percentages.

Example Usage
-----------------

```
module "alarm" {
  source = "git@github.com:techservicesillinois/terraform-aws-cloudwatch-alarm"

  name = "foo"

  subscriptions = [
      {
        protocol = "email"
        endpoint = "admin@example.com"
      },

      {
        protocol = "sms"
        endpoint = "+18005551212"
      },
  ]

  ecs_services = {
    "foo-daemon" = {
      cpu    = 90
      memory = 85
    },

    "foo-ui" = {
      cpu    = 75
      memory = 75
    }
  }
}
```

Argument Reference
-----------------

The following arguments are supported:

* `ecs_cluster` – (Optional) ECS cluster containing services for which alarms
are created.

* `ecs_services` – (Optional) Map of ECS services for which metric alarms are created; key is name of service and value is an object with the attributes `cpu` and `memory`.
Both attributes are numeric values.

* `name` – (Required) Service name. This is used to form the name of metric alarm(s).

* `subscriptions` (Optional) A [subscriptions](#subscriptions) block. The
`subscriptions` block is documented below.

* `tags` – (Optional) Tags to be applied to resources where supported.

`subscriptions`
------------------

A `subscription` block consists of a list containing one or more maps, wherein each
map must contain the following keys:

* `endpoint` – (Required) The endpoint to send data to, the contents will
vary with the protocol.

* `protocol` – (Required) The protocol to use. The fully-supported values
for this are: `email`, `sqs`, `sms`, `lambda`, `application`.

Additionally, `http` and `https` protocols are only partially supported by
Terraform.

For further information, see the documentation on Terraform's
[terraform-sns-topic-subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) resource. The
[Amazon documentation on the Simple Notification Service (SNS)](https://docs.aws.amazon.com/sns/latest/dg/welcome.html) may also be helpful.

Attributes Reference
--------------------

The following attributes are exported:

* `metric_alarms` – List consisting of ARNs of each CloudWatch metric alarm managed by the module.

* `subscriptions` – List containing the subscriptions managed for the SNS topic. The format of each member of this list is `protocol:endpoint`.

* `topic` - ARN of the SNS topic used for this service.
