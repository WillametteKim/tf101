provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "example" {
  name = "neo"
}

resource "aws_iam_user_policy_attachment" "neo_cloudwatch_full_access" {
  count = var.give_neo_cloudwatch_full_access ? 1 : 0

  user       = aws_iam_user.example.name
  policy_arn = aws_iam_policy.cloudwatch_full_access.arn
}

resource "aws_iam_user_policy_attachment" "neo_cloudwatch_read_only" {
  count = var.give_neo_cloudwatch_full_access ? 0 : 1

  user       = aws_iam_user.example.name
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}
