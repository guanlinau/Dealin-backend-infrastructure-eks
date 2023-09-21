locals {
  node_group_tag = "${var.cluster_name}-${var.node_group_visibility}"
}
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = local.node_group_tag
  node_role_arn   = var.eks_nodegroup_role_arn
  subnet_ids      = var.subnet_ids
  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  ami_type = var.ami_type

  capacity_type = var.capacity_type
  disk_size     = var.disk_size

  instance_types = var.instance_types

  version = var.eks_cluster_version
  remote_access {
    ec2_ssh_key = var.private_remote_access_key_name
  }

  update_config {
    max_unavailable = var.max_unavailable_work_node
  }

  tags = {
    Name = "${local.node_group_tag}-node-group"
    # Cluster Autoscaler Tags
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"             = "true"
    "kubernetes.io/cluster/${var.cluster_name}"     = "owned"
  }
}
