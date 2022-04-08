provider "aws" {
  region  = "af-south-1"
}

resource "aws_guardduty_detector" "GuardDuty" {
  enable = true
}

module "SnsTopic1" {
  source = "github.com/asecurecloud/tf_sns_email"

  display_name = "sns-topic"
  email_address = "email@example.com"
  stack_name = "tf-cfn-stack-SnsTopic1-kWFbA"
}



resource "aws_cloudwatch_event_rule" "CwEvent2" {
  name = "detect-guardduty-finding"
  description = "A CloudWatch Event Rule that triggers on Amazon GuardDuty findings. The Event Rule can be used to trigger notifications or remediative actions using AWS Lambda."
  is_enabled = true
  event_pattern = <<PATTERN
{
  "detail-type": [
    "GuardDuty Finding"
  ],
  "source": [
    "aws.guardduty"
  ]
}
PATTERN

}

resource "aws_cloudwatch_event_target" "TargetForCwEvent2" {
  rule = aws_cloudwatch_event_rule.CwEvent2.name
  target_id = "target-id1"
  arn = module.SnsTopic1.arn
}