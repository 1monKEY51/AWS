provider "aws" {
}

resource "aws_wafv2_web_acl_association" "WafWebAclAssociation" {
  resource_arn = "Resource Arn"
  web_acl_arn = aws_waf_web_acl.WafWebAcl.arn
}

resource "aws_wafv2_web_acl" "WafWebAcl" {
  name = "WAF_Common_Protections"
  scope = "REGIONAL"
  description = "Simple ACL for common WAF protection"

  default_action {
    allow {
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name = "WAF_Common_Protections"
    sampled_requests_enabled = true
  }

  rule {
    name = "AWSManagedRulesCommonRule"
    priority = 0
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
      metric_name = "AWSManagedRulesCommonRule"
      sampled_requests_enabled = true
    }
  }
  rule {
    name = "AWSManagedRulesKnownBadInputsRule"
    priority = 1
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
      metric_name = "AWSManagedRulesKnownBadInputsRule"
      sampled_requests_enabled = true
    }
  }
  rule {
    name = "AWSManagedRulesAmazonIpReputation"
    priority = 2
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
      metric_name = "AWSManagedRulesAmazonIpReputation"
      sampled_requests_enabled = true
    }
  }
}
