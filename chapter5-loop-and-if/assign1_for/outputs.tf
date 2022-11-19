output "all_users" {
  value = aws_iam_user.myiam
}

output "arns" {
  value = values(aws_iam_user.myiam)[*].arn
}