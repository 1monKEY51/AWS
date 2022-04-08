# S3 Security Controls:
### S3SecurityControl.tf & S3SecurityControl.yml

Configuration for creating an S3 bucket with security options such as S3 block public access configuration, encryption, logging, and versioning.

S3 bucket = mybucket
Enable Object Versioning = Yes
Server Side Encryption = S3-SSE
Public Access Settings:
  ~ block public acls = true
  ~ block public policy = true
  ~ ignore public acls = true
  ~ restrict public buckets = true
Predefined ACL = PublicRead
tf only: region setting as af-south-1

# S3 Bucket SSL Policies
### S3_SSL_Policy.tf & S3_SSL_Policy.yml

An S3 Bucket policy that prevents access to the S3 bucket that is not encrypted in transit (uses HTTP rather than HTTPS).
tf only: region setting as af-south-1

# WAF
### WAF.tf & WAF.yml

Configuration to create WAF Web ACLs with AWS Managed Rules to protect internet-facing applications.
Rules:
	AWSManagedRulesAnonymousIpList
	AWSManagedRulesAmazonIpReputationList
	AWSManagedRulesCommonRuleSet
	AWSManagedRulesKnownBadInputsRuleSet

# PCI DSS Compliance Monitoring with Security Hub:
### PCI-DSS_SecurityHub_Monitoring.tf & PCI-DSS_SecurityHub_Monitoring.yml

A configuration package that enables compliance monitoring for a subset of the PCI DSS 3.2.1 controls in an AWS account using the AWS Security Hub. The configuration package also includes enabling service prerequisites and configuring Security Hub notifications. By default, the AWS Security Hub activates the CIS AWS Foundations Compliance Standards.

~ AWS Config is required in order to enable Compliance Standards in the Security Hub (CIS AWS Foundations, and PCI DSS).
~ Configure a CloudWatch Event Rule to match on Security Hub findings and send notifications to an SNS topic.

# Amazon GuardDuty
### AWS_GuardDuty.tf & AWS_GuardDuty.yml

Protects your AWS accounts and workloads by continuously monitoring for malicious activity and unauthorized behavior.
In addition to the above services, the following additional configuration can be enabled:
Email Notifications: Enable notifications for GuardDuty and Security Hub using CloudWatch Event Rules and SNS.

# AWS Simple VPC
### AWS_VPC.tf & AWS_VPC.yml

A configuration package for deploying an Amazon VPC that includes predefined presets for Subnet Tiers (Public and Private), Availability Zones, and Internet Connectivity.
Subnets, Routing Tables, Internet Gateways & Nat Gateway
