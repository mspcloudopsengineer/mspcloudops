# 睿鸿股份有限公司 - AWS 基础设施
# Release Management Demo

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  description = "环境名称"
  type        = string
}

variable "project_name" {
  default = "ruihong"
}

# S3 存储桶 - 演示资源
resource "aws_s3_bucket" "demo" {
  bucket = "${var.project_name}-${var.environment}-demo-${random_id.suffix.hex}"
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-demo"
    Environment = var.environment
    Project     = "Release Management Demo"
    Customer    = "睿鸿股份有限公司"
    ManagedBy   = "Terraform"
    Version     = "v1.0.0"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

output "bucket_name" {
  value = aws_s3_bucket.demo.id
}

output "environment" {
  value = var.environment
}
