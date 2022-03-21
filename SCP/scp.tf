provider "aws" {
  region  = "af-south-1"
}

resource "aws_organizations_policy" "ScpPolicy1" {
  name = "scp_account_protection"
  description = "scp_account_protection"
  content = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Resource": "*",
      "Effect": "Deny",
      "Condition": {
        "StringLike": {
          "aws:PrincipalArn": [
            "arn:aws:iam::*:root"
          ]
        }
      }
    },
    {
      "Action": [
        "organizations:LeaveOrganization"
      ],
      "Resource": "*",
      "Effect": "Deny"
    }
  ]
}
POLICY

}

resource "aws_organizations_policy" "ScpPolicy2" {
  name = "scp_logging_services_protection"
  description = "scp_logging_services_protection"
  content = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudtrail:StopLogging",
        "cloudtrail:DeleteTrail"
      ],
      "Resource": "*",
      "Effect": "Deny"
    },
    {
      "Action": [
        "config:DeleteConfigRule",
        "config:DeleteConfigurationRecorder",
        "config:DeleteDeliveryChannel",
        "config:StopConfigurationRecorder"
      ],
      "Resource": "*",
      "Effect": "Deny"
    },
    {
      "Action": [
        "guardduty:DeleteDetector",
        "guardduty:DeleteInvitations",
        "guardduty:DeleteIPSet",
        "guardduty:DeleteMembers",
        "guardduty:DeleteThreatIntelSet",
        "guardduty:DisassociateFromMasterAccount",
        "guardduty:DisassociateMembers",
        "guardduty:StopMonitoringMembers",
        "guardduty:UpdateDetector"
      ],
      "Resource": "*",
      "Effect": "Deny"
    },
    {
      "Action": [
        "securityhub:DeleteInvitations",
        "securityhub:DisableSecurityHub",
        "securityhub:DisassociateFromMasterAccount",
        "securityhub:DeleteMembers",
        "securityhub:DisassociateMembers"
      ],
      "Resource": "*",
      "Effect": "Deny"
    },
    {
      "Action": [
        "ec2:DeleteFlowLogs",
        "logs:DeleteLogGroup",
        "logs:DeleteLogStream"
      ],
      "Resource": "*",
      "Effect": "Deny"
    }
  ]
}
POLICY

}

resource "aws_organizations_policy" "ScpPolicy3" {
  name = "scp_iam_protection"
  description = "scp_iam_protection"
  content = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iam:CreateUser",
        "iam:CreateAccessKey"
      ],
      "Resource": [
        "*"
      ],
      "Effect": "Deny"
    }
  ]
}
POLICY

}

resource "aws_organizations_policy" "ScpPolicy4" {
  name = "scp_s3_protection"
  description = "scp_s3_protection"
  content = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutAccountPublicAccessBlock"
      ],
      "Resource": "*",
      "Effect": "Deny"
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "*",
      "Effect": "Deny",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      }
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "*",
      "Effect": "Deny",
      "Condition": {
        "Bool": {
          "s3:x-amz-server-side-encryption": false
        }
      }
    }
  ]
}
POLICY

}
