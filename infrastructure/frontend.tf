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

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
# test