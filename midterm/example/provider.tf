provider "aws" {
  region  = var.region
  profile = var.profile
}

module "env" {
  source = "git::git@github.com:WillametteKim/tf101.git//midterm/"
}
