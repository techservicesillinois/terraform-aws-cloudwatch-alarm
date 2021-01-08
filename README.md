# cloudwatch-alarm

[![Terraform actions status](https://github.com/techservicesillinois/terraform-aws-cloudwatch-alarm/workflows/terraform/badge.svg)](https://github.com/techservicesillinois/terraform-aws-cloudwatch-alarm/actions)

Provides CloudWatch alarms. This module's support is currently limited to ECS
services, and currently supports only the `CPUUtilization` and `MemoryUtilization`
metrics.

In this minimum viable implementation, the CloudWatch alarm period,
statistic, and threshold are hardcoded, though different thresholds are
applied to the `CPUUtilization` and `MemoryUtilization` metrics.

Example Usage
-----------------

```
module "alarm" {
  source = "git@github.com:techservicesillinois/terraform-aws-cloudwatch-alarm"

    name = "foo"

  subscriptions = [
      {
        protocol = "sms"
        endpoint = "+18005551212"
      },
  ]

  ecs_cluster = "foo"

  ecs_services = [
    "foo-daemon",
    "foo-ui",
  ]

}
```

Argument Reference
-----------------

The following arguments are supported:

* `ecs_cluster` – (Required) ECS cluster containing services for which alarms
are created

* `ecs_services` – (Optional) List of ECS services for which alarms are created.

* `name` – (Required) Service name. This is used to form the name of alarm(s).

* `subscriptions` (Optional) A [subscriptions](#subscriptions) block. The
`subscriptions` block is documented below.

* `tags` – (Optional) Tags to be applied to resources where supported.

`subscriptions`
------------------

A `subscription` block consists of a list containing one or more maps, each
of which must contain the following keys:

* `protocol` – (Required) The protocol to use. The fully-supported values
for this are: `sqs`, `sms`, `lambda`, `application`.

* `endpoint` – (Required) The endpoint to send data to, the contents will
vary with the protocol.

**Note:** AWS supports additional `email` and `email-json` protocols that are
not supported by Terraform because the authorization process does not generate
an ARN until the target email address has been validated.
However, subscriptions using the `email` and `email-json` protocols can be
created in the AWS console.

Additionally, `http` and `https` protocols are only partially supported by
Terraform.

For further information, see the documentation on Terraform's
[terraform-sns-topic-subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) resource. The
[Amazon documentation on the Simple Notification Service (SNS)](https://docs.aws.amazon.com/sns/latest/dg/welcome.html) may also be helpful.

Attributes Reference
--------------------

The following attributes are exported:

* `alarm_arn` – List consisting of ARNs of each alarm managed by the module.

* `topic_arn` - ARN of the SNS alarm topic for this service.
