terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.60.0"
    }
  }

  backend "s3" {
    region         = "ap-south-1"
    bucket         = ""
    key            = ""
    dynamodb_table = "Lock-Files"
    encrypt        = true
  }
}
provider "aws" {
  region  = "ap-south-1"
}