// main.tf trigger a test run again
terraform {
  required_version = ">= 1.14.4"
  required_providers { aws = { source = "hashicorp/aws" } }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "${var.project_name}-vpc", Environment = var.environment }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.project_name}-public-subnet", Environment = var.environment }
}

resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  tags          = { Name = "${var.project_name}-app", Environment = var.environment }
}

resource "aws_s3_bucket" "data" {
  count  = var.create_bucket ? 1 : 0
  bucket = "${var.project_name}-data-${var.environment}"
  tags   = { Name = "${var.project_name}-data", Environment = var.environment }
}
