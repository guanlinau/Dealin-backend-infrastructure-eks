output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_AmazonEKSClusterPolicy_id" {
  value = aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy.id
}

output "eks_AmazonEKSVPCResourceController_id" {
  value = aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController.id
}

output "eks_nodegroup_role_arn" {
  value = aws_iam_role.eks_nodegroup_role[0].arn
}

output "eks_AmazonEKSWorkerNodePolicy_id" {
  value = aws_iam_role_policy_attachment.eks_AmazonEKSWorkerNodePolicy[0].id
}
output "eks_AmazonEKS_CNI_Policy_id" {
  value = aws_iam_role_policy_attachment.eks_AmazonEKS_CNI_Policy[0].id
}
output "eks_AmazonEC2ContainerRegistryReadOnly_id" {
  value = aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly[0].id
}

# output "fargate_profile_role_arn" {
#   value = aws_iam_role.fargate_profile_role[0].arn
# }