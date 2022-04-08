provider "aws" {
  region  = "af-south-1"
}

resource "aws_s3_bucket" "S3Bucket" {
  bucket = "mybucket"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::mybucket/*",
        "arn:aws:s3:::mybucket"
      ],
      "Effect": "Deny",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}