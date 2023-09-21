output "eks_node_group_arn" {
  value = aws_eks_node_group.eks_node_group.arn
}

output "eks_node_group_security_group_id" {
  value = [for resource in aws_eks_node_group.eks_node_group.resources : resource.remote_access_security_group_id][0]
}

output "eks_node_group_status" {
  value = aws_eks_node_group.eks_node_group.status
}
output "eks_node_group_id" {
  value = aws_eks_node_group.eks_node_group.id
}