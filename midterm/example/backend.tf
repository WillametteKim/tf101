terraform {
  backend "s3" {
    bucket         = "willamette-t101study-tfstate"
    key            = "chaos-monkey/redis/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-lock"
  }
}
