# Create eks cluster iam role and attach policy to it
data "aws_iam_policy_document" "assume_eks_cluster_role_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    sid     = ""
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.app_name}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assume_eks_cluster_role_policy.json
  tags = {
    Name = "${var.app_name}-eks-cluster-role"
  }
}

# Associate IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}


# Create node group iam role and attach policy to it
data "aws_iam_policy_document" "assume_node_group_role_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    sid     = ""
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_nodegroup_role" {
  count              = var.create_node_group ? 1 : 0
  name               = "${var.app_name}-eks-node_group_role"
  assume_role_policy = data.aws_iam_policy_document.assume_node_group_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSWorkerNodePolicy" {
  count      = var.create_node_group ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodegroup_role[0].name
  depends_on = [aws_iam_role.eks_nodegroup_role[0]]
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKS_CNI_Policy" {
  count      = var.create_node_group ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodegroup_role[0].name
  depends_on = [aws_iam_role.eks_nodegroup_role[0]]
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEC2ContainerRegistryReadOnly" {
  count      = var.create_node_group ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodegroup_role[0].name
  depends_on = [aws_iam_role.eks_nodegroup_role[0]]
}

# CloudWatchAgentServerPolicy for AWS CloudWatch Container Insights ---->This is for cloudwatch agent 
resource "aws_iam_role_policy_attachment" "eks_cloudwatch_container_insights" {
  count      = var.create_node_group ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_nodegroup_role[0].name
}

# Autoscaling Full Access
# resource "aws_iam_role_policy_attachment" "eks-Autoscaling-Full-Access" {
#  count              = var.create_node_group ? 1 : 0
#   policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
#   role       = aws_iam_role.eks_nodegroup_role[0].name
# }

# # Other common policies for node group : Get access to route 53 policy for 
# data "aws_iam_policy_document" "common_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "route53:ChangeResourceRecordSets",
#       "route53:ListResourceRecordSets",
#       "route53:ListHostedZones",
#       "route53:ListTagsForResource"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "common_policy" {
#   name        = "AmazonEKSPodRolePolicy"
#   description = "AmazonEKSPodRolePolicy"
#   policy      = data.aws_iam_policy_document.common_policy.json
#   tags = {
#     Name = "${var.app_name}-pod_iam_common-policy"
#   }
# }
# # Attach the common policy to node group
# resource "aws_iam_role_policy_attachment" "eks_pod_common_policy" {
#  count              = var.create_node_group ? 1 : 0
#   policy_arn = aws_iam_policy.common_policy.arn
#   role       = aws_iam_role.eks_nodegroup_role[0].name
#   depends_on = [aws_iam_role.eks_nodegroup_role[0]]
# }

# Create iam role and iam policy to fargate profile
resource "aws_iam_role" "fargate_profile_role" {
  count = var.create_fargate == true ? 1 : 0
  name  = "${var.app_name}-eks-fargate-profile-role-apps"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_fargate_pod_execution_role_policy" {
  count      = var.create_fargate == true ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_profile_role[0].name
  depends_on = [aws_iam_role.fargate_profile_role[0]]
}
resource "aws_iam_role_policy_attachment" "eks_fargate_cloudwatch_container_insights" {
  count      = var.create_fargate == true ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.fargate_profile_role[0].name
  depends_on = [aws_iam_role.fargate_profile_role[0]]
}