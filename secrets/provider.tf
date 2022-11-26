provider "aws" {
  region = "ap-northeast-2"
}

data "aws_caller_identity" "self" {}