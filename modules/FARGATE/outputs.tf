output "fargate_arn" {
  value = aws_eks_fargate_profile.fargate_profile.arn
}

output "fargate_id" {
  value = aws_eks_fargate_profile.fargate_profile.id
}