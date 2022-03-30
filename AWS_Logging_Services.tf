provider "aws" {
}

resource "aws_s3_bucket" "S3SharedBucket" {
  bucket = "s3-bucket-random-name-JIqdTOfwpuIEHln"
  acl = "log-delivery-write"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = "s3-bucket-random-name-JIqdTOfwpuIEHln"
    target_prefix = ""
  }
}

resource "aws_s3_bucket_public_access_block" "blockPublicAccess" {
  bucket = aws_s3_bucket.S3SharedBucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
  depends_on = [ aws_s3_bucket_policy.BucketPolicy ]
}

data "aws_iam_policy_document" "s3-bucket-policy-forS3SharedBucket" {

  statement {
    actions = ["s3:GetBucketAcl"]
    effect = "Allow"
    resources = [aws_s3_bucket.S3SharedBucket.arn]
    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com","config.amazonaws.com"]
    }
  }
  statement {
    actions = ["s3:PutObject"]
    effect = "Allow"
    resources = [join("",["",aws_s3_bucket.S3SharedBucket.arn,"/*"])]
    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com","config.amazonaws.com"]
    }
    condition {
      test = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"]
    }
  }
}
resource "aws_s3_bucket_policy" "BucketPolicy" {
  bucket = aws_s3_bucket.S3SharedBucket.id
  policy = data.aws_iam_policy_document.s3-bucket-policy-forS3SharedBucket.json
}

resource "aws_cloudtrail" "CloudTrail" {
  name = "ManagementEventsTrail"
  s3_bucket_name = aws_s3_bucket.S3SharedBucket.id
  is_multi_region_trail = true
  enable_log_file_validation = true
  cloud_watch_logs_group_arn = "CloudTrailLogs"
  cloud_watch_logs_role_arn = aws_iam_role.CwLogIamRole.arn
  depends_on = [ aws_s3_bucket_policy.BucketPolicy ]

  event_selector {
    include_management_events = true
    read_write_type = "All"
  }
}

resource "aws_iam_role" "CwLogIamRole" {
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["cloudtrail.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "CwLogIamRoleInlinePolicyRoleAttachment0" {
  name = "allow-access-to-cw-logs"
  role = aws_iam_role.CwLogIamRole.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}





resource "aws_cloudwatch_log_group" "CWLogGroupForCloudTrail" {
  name = "CloudTrailLogs"
  retention_in_days = 90
}

resource "aws_config_configuration_recorder" "ConfigurationRecorder" {
  role_arn = aws_iam_role.ConfigIamRole.arn

  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "DeliveryChannel" {
  s3_bucket_name = aws_s3_bucket.S3SharedBucket.id
  depends_on = [ aws_config_configuration_recorder.ConfigurationRecorder ]
}

resource "aws_config_configuration_recorder_status" "ConfigurationRecorderStatus" {
  name = aws_config_configuration_recorder.ConfigurationRecorder.name
  is_enabled = true
  depends_on = [ aws_config_delivery_channel.DeliveryChannel ]
}

resource "aws_iam_role" "ConfigIamRole" {
  name = "iamRoleForAWSConfig"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["config.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "ConfigIamRoleManagedPolicyRoleAttachment0" {
  role = aws_iam_role.ConfigIamRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_iam_role_policy" "ConfigIamRoleInlinePolicyRoleAttachment0" {
  name = "allow-access-to-config-s3-bucket"
  role = aws_iam_role.ConfigIamRole.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::s3-bucket-random-name-DhOip/*"
            ],
            "Condition": {
                "StringLike": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketAcl"
            ],
            "Resource": "arn:aws:s3:::s3-bucket-random-name-DhOip"
        }
    ]
}
POLICY
}





resource "aws_guardduty_detector" "GuardDuty" {
  enable = true
}
