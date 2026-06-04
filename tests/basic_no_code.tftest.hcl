# tests/basic_no_code.tftest.hcl
#
# Basic no-code module test using mocked AWS provider.
# Validates that all resources are created with correct attributes.

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
  mock_resource "aws_s3_bucket" {
    defaults = {
      arn    = "arn:aws:s3:::nocode-demo-data-dev"
      id     = "nocode-demo-data-dev"
      bucket = "nocode-demo-data-dev"
    }
  }
}

run "create_all_resources" {
  command = apply

  variables {
    project_name  = "nocode-demo"
    environment   = "dev"
    vpc_cidr      = "10.0.0.0/16"
    subnet_cidr   = "10.0.1.0/24"
    ami_id        = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    create_bucket = true
  }

  assert {
    condition     = output.vpc_id == "vpc-0abc12345def67890"
    error_message = "VPC ID mismatch"
  }

  assert {
    condition     = output.subnet_id == "subnet-0abc12345def67890"
    error_message = "Subnet ID mismatch"
  }

  assert {
    condition     = output.instance_id == "i-0abc12345def67890"
    error_message = "Instance ID mismatch"
  }

  assert {
    condition     = output.instance_public_ip == "198.51.100.42"
    error_message = "Instance public IP mismatch"
  }

  assert {
    condition     = output.bucket_name == "nocode-demo-data-dev"
    error_message = "Bucket name mismatch"
  }

  assert {
    condition     = output.bucket_arn == "arn:aws:s3:::nocode-demo-data-dev"
    error_message = "Bucket ARN mismatch"
  }
}
