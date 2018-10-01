terraform {
  backend "s3" {
    bucket         = "terraform-2018"
    region         = "us-east-1"
    key            = "eks-jk"
    dynamodb_table = "terraform-state-locking"
  }
}

provider "aws" {
  region  = "us-east-1"
  version = "1.37.0"
}

data "aws_caller_identity" "current" {}
