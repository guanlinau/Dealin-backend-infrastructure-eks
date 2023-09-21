output "eks_cluster_api_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks_cluster.id
}
output "eks_cluster_arn" {
  value = aws_eks_cluster.eks_cluster.arn
}

output "eks_cluster_status" {
  value = aws_eks_cluster.eks_cluster.status
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_token" {
  value = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

output "eks_cluster_openid_connect_provider_url" {
  value = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}