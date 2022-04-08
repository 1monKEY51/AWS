provider "aws" {
  region  = "af-south-1"
}

resource "aws_s3_bucket" "S3Bucket" {
  bucket = "mybucket"
  acl = "public-read"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "blockPublicAccess" {
  bucket = aws_s3_bucket.S3Bucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}