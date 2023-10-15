terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.21.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "crc-frontend" {
  bucket = "crc-frontend-static"
}

resource "aws_s3_bucket_website_configuration" "crc-frontend-web-conf" {
  bucket = aws_s3_bucket.crc-frontend.id

  index_document {
    suffix = "index.html"
  }
}

# ff