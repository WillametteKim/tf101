terraform {
  backend "s3" {
    bucket         = "willamette-t101study-tfstate"
    key            = "stg/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
    # encrypt        = true
  }
}
