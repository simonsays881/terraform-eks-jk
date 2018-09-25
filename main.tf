terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-2018"
    key            = "eks-jk"
    dynamodb_table = "terraform-state-locking"
  }
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.37.0"
}

data "aws_caller_identity" "current" {}

