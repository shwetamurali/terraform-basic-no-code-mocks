# tests/no_bucket.tftest.hcl
#
# Tests the module with bucket creation disabled.

mock_provider "aws" {
  mock_resource "aws_vpc" {
    defaults = {
      id = "vpc-0abc12345def67890"
    }
  }
  mock_resource "aws_subnet" {
    defaults = {
      id = "subnet-0abc12345def67890"
    }
  }
  mock_resource "aws_instance" {
    defaults = {
      id        = "i-0abc12345def67890"
      public_ip = "198.51.100.42"
    }
  }
}

run "create_without_bucket" {
  command = apply

  variables {
    project_name  = "nocode-demo"
    environment   = "dev"
    create_bucket = false
  }

  assert {
    condition     = output.vpc_id == "vpc-0abc12345def67890"
    error_message = "VPC ID mismatch"
  }

  assert {
    condition     = output.instance_id == "i-0abc12345def67890"
    error_message = "Instance ID mismatch"
  }

  assert {
    condition     = output.bucket_name == null
    error_message = "Bucket name should be null when create_bucket is false"
  }

  assert {
    condition     = output.bucket_arn == null
    error_message = "Bucket ARN should be null when create_bucket is false"
  }
}
