
resource "aws_eks_fargate_profile" "fargate_profile" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = "${var.cluster_name}-fargate-${var.namespace_name}"
  pod_execution_role_arn = var.pod_execution_role_arn
  subnet_ids             = var.private_subnet_ids

  selector {
    namespace = var.namespace_name
    labels    = var.fargate_selector_labels_pair
  }
  tags = {
    Name = "${var.cluster_name}-fargate-${var.namespace_name}"
  }
}