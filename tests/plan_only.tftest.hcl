# tests/plan_only.tftest.hcl
#
# Plan-only test to validate configuration without applying.

mock_provider "aws" {
  mock_resource "aws_vpc" {
    defaults = {
      id = "vpc-plan-only"
    }
  }
  mock_resource "aws_subnet" {
    defaults = {
      id = "subnet-plan-only"
    }
  }
  mock_resource "aws_instance" {
    defaults = {
      id        = "i-plan-only"
      public_ip = "10.0.0.1"
    }
  }
  mock_resource "aws_s3_bucket" {
    defaults = {
      arn    = "arn:aws:s3:::staging-data"
      id     = "staging-data"
      bucket = "staging-data"
    }
  }
}

run "plan_with_custom_variables" {
  command = plan

  variables {
    project_name  = "staging"
    environment   = "staging"
    vpc_cidr      = "172.16.0.0/16"
    subnet_cidr   = "172.16.1.0/24"
    ami_id        = "ami-0987654321abcdef0"
    instance_type = "t3.small"
    create_bucket = true
  }

  assert {
    condition     = aws_vpc.main.cidr_block == "172.16.0.0/16"
    error_message = "VPC CIDR block mismatch"
  }

  assert {
    condition     = aws_instance.app.instance_type == "t3.small"
    error_message = "Instance type mismatch"
  }

  assert {
    condition     = aws_subnet.public.map_public_ip_on_launch == true
    error_message = "Subnet should map public IP on launch"
  }
}
