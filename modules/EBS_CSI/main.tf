# Install EBS CSI Driver using EKS Add-Ons
resource "aws_eks_addon" "ebs_eks_addon" {
  cluster_name             = var.cluster_name
  addon_name               = var.ebs_addon_name
  service_account_role_arn = var.service_account_role_arn
}