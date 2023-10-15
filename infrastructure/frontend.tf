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

resource "aws_s3_bucket_ownership_controls" "crc-frontend-ownership-control" {
  bucket = aws_s3_bucket.crc-frontend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "crc-frontend-public-access" {
  bucket = aws_s3_bucket.crc-frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership-control,
    aws_s3_bucket_public_access_block.crc-frontend-public-access,
  ]

  bucket = aws_s3_bucket.crc-frontend.id
  acl    = "public-read"
}


resource "aws_s3_bucket_website_configuration" "crc-frontend-web-conf" {
  bucket = aws_s3_bucket.crc-frontend.id

  index_document {
    suffix = "index.html"
  }
}

# ff

