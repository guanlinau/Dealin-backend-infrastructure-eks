output "controller_iam_role_arn" {
  value = aws_iam_role.controller_iam_role.arn
}

output "controller_iam_role_policy_attach" {
  value = aws_iam_role_policy_attachment.controller_iam_role_policy_attach
}
