provider "aws" {
  region  = "af-south-1"
}

resource "aws_wafv2_web_acl" "WafWebAcl" {
  name = "MyWebACL"
  scope = "REGIONAL"
  description = "AWSManagedRulesAnonymousIpList, AWSManagedRulesAmazonIpReputationList, AWSManagedRulesCommonRuleSet & AWSManagedRulesKnownBadInputsRuleSet ."

  default_action {
    allow {
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name = "MyWebACL"
    sampled_requests_enabled = true
  }

  rule {
    name = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2
    override_action {
      none {
      }
    }
    statement {
      managed_rule_group_statement {
        name = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled = true
    }
  }
  rule {
    name = "AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {
      }
    }
    statement {
      managed_rule_group_statement {
        name = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled = true
    }
  }
  rule {
    name = "AWSManagedRulesAmazonIpReputationList"
    priority = 4
    override_action {
      none {
      }
    }
    statement {
      managed_rule_group_statement {
        name = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled = true
    }
  }
  rule {
    name = "AWSManagedRulesAnonymousIpList"
    priority = 5
    override_action {
      none {
      }
    }
    statement {
      managed_rule_group_statement {
        name = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled = true
    }
  }
}