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

module "backend" {
  source = "./back-end"
  
}

module "frontend" {
  source = "./front-end"
  
}