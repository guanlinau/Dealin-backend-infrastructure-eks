region                      = "ap-southeast-2"
app_name                    = "offerripple"
vpc_cidr_block              = "10.0.0.0/16"
private_subnets_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets_cidr_blocks  = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones          = ["ap-southeast-2a", "ap-southeast-2b"]

# For Create node group or fargate
# If you want to create node group, please give the value true, otherwise false in iam module
create_node_group = true
# If you want to use fargate, please give the value true, otherwsie false here
create_fargate = false

# For ACM
domain_name       = "offerripple.com"
validation_method = "DNS"
key_algorithm     = "RSA_2048"

# For iam aws load balancer ingress controller
lbc_ingress_controller_iam_policy_url      = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json"
lb_ingress_controller_service_account_name = "aws-load-balancer-controller"
lb_ingress_controller_name_space           = "kube-system"

# For iam external dns controller
external_dns_service_account_name = "external-dns"
external_dns_namespace            = "default"
iam_policy_row_data = {
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource" : [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets",
        "route53:ListTagsForResource"
      ],
      "Resource" : [
        "*"
      ]
    }
  ]
}

# For iam cluster auto scaler
cluster_autoscaler_namespace            = "kube-system"
cluster_autoscaler_service_account_name = "cluster-autoscaler"
cluster_autoscaler_iam_policy_row_data = {
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Action" : [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeScalingActivities",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions",
        "ec2:DescribeInstanceTypes",
        "ec2:GetInstanceTypesFromInstanceRequirements",
        "ec2:DescribeImages",
        "autoscaling:DescribeInstances",
        "eks:DescribeNodegroup"
      ],
      "Resource" : ["*"],
      "Effect" : "Allow"
    }
  ]
}

# For iam ebs csi
iam_ebs_csi_iam_policy_url       = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"
iam_ebs_csi_service_account_name = "ebs-csi-controller-sa"
iam_ebs_csi_namespace            = "kube-system"


# For eks cluster
cluster_endpoint_private_access      = true
cluster_endpoint_public_access       = true
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
eks_cluster_version                  = "1.27"
cluster_service_ipv4_cidr            = "172.20.0.0/16"
timeouts_delete_time                 = "30m"


#If you want to create node groups, please fill the following variable values 
node_group_visibility          = "private"
node_group_desired_size        = 2
node_group_max_size            = 5
node_group_min_size            = 2
max_unavailable_work_node      = 1
ami_type                       = "AL2_x86_64"
capacity_type                  = "ON_DEMAND"
disk_size                      = 30 #is in GiB
instance_types                 = ["t3.medium"]
private_remote_access_key_name = "offerripple-eks"

#For aws lb ingress controller helm
aws_lb__ingress_controller_repository_url = "https://aws.github.io/eks-charts"
aws_lb_ingress_controller_chart_name      = "aws-load-balancer-controller"
aws_lb_ingress_controller_set_values_list = [
  {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.ap-southeast-2.amazonaws.com/amazon/aws-load-balancer-controller"
    #"The image repository of the controller.If you're deploying to any Region other than us-west-2, then add the following flag to the command that you run, replacing account and region-code with the values for your region listed in Amazon EKS add-on container image addresses. https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html"
  },
  {
    name  = "serviceAccount.create"
    value = "true"
  },
  {
    name  = "region"
    value = "ap-southeast-2"
  },
  {
    name  = "tolerations[0].key"
    value = "eks.amazonaws.com/compute-type"
  },
  {
    name  = "tolerations[0].operator"
    value = "Equal"
  },
  {
    name  = "tolerations[0].value"
    value = "fargate"
  },
  {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }
]
# For external dns controller
external_dns_controller_repo_url = "https://kubernetes-sigs.github.io/external-dns/"
external_dns_chart_name          = "external-dns"
external_dns_set_values_list = [
  {
    name = "image.repository"
    # value = "k8s.gcr.io/external-dns/external-dns"
    value = "registry.k8s.io/external-dns/external-dns"
  },
  {
    name  = "serviceAccount.create"
    value = "true"
  },
  {
    name  = "provider" # Default is aws (https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns)
    value = "aws"
  },
  {
    name  = "policy" # Default is "upsert-only" which means DNS records will not get deleted even equivalent Ingress resources are deleted (https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns)
    value = "sync"   # "sync" will ensure that when ingress resource is deleted, equivalent DNS record in Route53 will get deleted
  },
  {
    name  = "tolerations[0].key"
    value = "eks.amazonaws.com/compute-type"
  },
  {
    name  = "tolerations[0].operator"
    value = "Equal"
  },
  {
    name  = "tolerations[0].value"
    value = "fargate"
  },
  {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }
]

# For cluster autoscler
cluster_autoscaler_repo_url   = "https://kubernetes.github.io/autoscaler"
cluster_autoscaler_chart_name = "cluster-autoscaler"
cluster_autoscaler_set_values_list = [
  {
    name  = "rbac.serviceAccount.create"
    value = "true"
  },
  {
    name  = "cloudProvider"
    value = "aws"
  },
  {
    name  = "extraArgs.skip-nodes-with-local-storage"
    value = "false"
  },
  {
    name  = "extraArgs.skip-nodes-with-system-pods"
    value = "false"
  },
  {
    name  = "extraArgs.ignore-daemonsets-utilization"
    value = "true"
  },
  {
    name  = "extraArgs.ignore-mirror-pods-utilization"
    value = "true"
  },
  {
    name  = "extraArgs.scale-down-utilization-threshold"
    value = "0.75"
  },
  {
    name  = "extraArgs.scale-down-unneeded-time"
    value = "5m"
  },
  {
    name  = "extraArgs.scale-down-delay-after-add"
    value = "5m"
  }
]

# For metric server
metric_server_repo_url   = "https://kubernetes-sigs.github.io/metrics-server/"
metric_server_chart_name = "metrics-server"
metric_server_namespace  = "kube-system"
metric_set_values_list = [
  {
    name  = "image.tag"
    value = ""
  },
  {
    name  = "apiService.insecureSkipTLSVerify"
    value = "true"
  }
]

# For Sonarqube
sonarqube_repo_url   = "https://SonarSource.github.io/helm-chart-sonarqube/"
sonarqube_chart_name = "sonarqube"
sonarqube_set_values_list = [
  {
    name  = "ingress.enabled"
    value = "true"
  },
  {
    name  = "ingress.ingressClassName"
    value = "alb"
  },
  {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/load-balancer-name"
    value = "offerripple-ip-ingress"
  },
  {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/target-type"
    value = "ip"
  },
  {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
    value = "internet-facing"
  },
  {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/listen-ports"
    value = "[{\"HTTP\": 80}\\,{\"HTTPS\": 443}]"
  },
  {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/ssl-redirect"
    value = "443"
  },
  {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.name"
    value = "dealin\\.offerripple"
  },
  {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.order"
    value = "20"
  },
  {
    name  = "persistence.enabled"
    value = "true"
  },
  {
    name  = "postgresql.persistence.size"
    value = "3Gi"
  }
]

# For ebs-addon
ebs_addon_name = "aws-ebs-csi-driver"

# For create namespace
ns_name_offerripple_uat   = "offerripple-uat"
ns_name_offerripple_pro   = "offerripple-pro"
ns_name_amazon_cloudwatch = "amazon-cloudwatch"
ns_name_sonarqube         = "sonarqube"


# For install vertical pod autoscaler
git_clone_command  = "git clone https://github.com/kubernetes/autoscaler.git"
install_vpa_path   = "autoscaler/vertical-pod-autoscaler/hack/vpa-up.sh"
removed_folder     = "autoscaler"
uninstall_vpa_path = "autoscaler/vertical-pod-autoscaler/hack/vpa-down.sh"

# For aws auth

aws_iam_users = [
  {
    aws_account_id = "023527796686"
    username       = "Jason"
    group          = "system:masters"
  },
  {
    aws_account_id = "023527796686"
    username       = "Charles"
    group          = "system:masters"
  },
  {
    aws_account_id = "023527796686"
    username       = "Flynn"
    group          = "system:masters"
  },
  {
    aws_account_id = "023527796686"
    username       = "Liang"
    group          = "system:masters"
  },
  {
    aws_account_id = "023527796686"
    username       = "Sean"
    group          = "system:masters"
  },
  {
    aws_account_id = "023527796686"
    username       = "Shelton"
    group          = "system:masters"
  },
  {
    aws_account_id = "023527796686"
    username       = "Skye"
    group          = "system:masters"
  },
  {
    aws_account_id = "023527796686"
    username       = "alex"
    group          = "system:masters"
  }
]

