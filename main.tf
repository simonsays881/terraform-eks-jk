terraform {
  backend "s3" {
    key            = "poc-eks-jenkins"
    dynamodb_table = "terraform-state-locking"
  }
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.35.0"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
