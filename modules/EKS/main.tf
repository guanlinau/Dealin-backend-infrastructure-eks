

#Create cloudwatch logs group
resource "aws_cloudwatch_log_group" "eks_cloudwatch_log_group" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${var.cluster_name}/log"
  retention_in_days = 7

  tags = {
    Name = "${var.cluster_name}-logs"
  }
}

# Create the eks cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn

  version = var.eks_cluster_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  encryption_config {
    provider {
      key_arn = var.key_arn
    }
    resources = ["secrets"]
  }
  # enable eks cluster controll plane logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  timeouts {
    delete = var.timeouts_delete_time
  }
  depends_on = [aws_cloudwatch_log_group.eks_cloudwatch_log_group]
}

#Output eks cluster auth token

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = aws_eks_cluster.eks_cluster.id
}


