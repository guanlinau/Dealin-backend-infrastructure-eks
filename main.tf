locals {
  cluster_name = "${var.app_name}-cluster"

  # for eks cluster
  subnet_ids = concat([for public_subnet in module.vpc.public_subnets : public_subnet.id], [for private_subnet in module.vpc.private_subnets : private_subnet.id])

  # for metric server
  metric_set_values_list = var.metric_set_values_list

  # for external dns controller
  external_dns_controller_set_values_list_internal = [{ name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn", value = module.iam_external_dns_controller.controller_iam_role_arn }, { name = "serviceAccount.name", value = var.external_dns_service_account_name }]
  combined_external_dns_set_values_list            = concat(var.external_dns_set_values_list, local.external_dns_controller_set_values_list_internal)

  # for aws lb ingress controller
  aws_lb_ingress_controller_set_values_list_internal = [{ name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn", value = module.iam_lb_ingress_controller.controller_iam_role_arn }, { name = "serviceAccount.name", value = var.lb_ingress_controller_service_account_name }, { name = "clusterName", value = module.eks.eks_cluster_id }, { name = "vpcId", value = module.vpc.vpc_id }]
  combined_aws_lb_ingress_controller_set_values_list = concat(var.aws_lb_ingress_controller_set_values_list, local.aws_lb_ingress_controller_set_values_list_internal)

  # for cluster autoscaler 
  cluster_autoscaler_set_values_list_internal = [{ name = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn", value = module.iam_cluster_autoscaler.controller_iam_role_arn }, { name = "rbac.serviceAccount.name", value = var.cluster_autoscaler_service_account_name }, { name = "autoDiscovery.clusterName", value = module.eks.eks_cluster_id }, { name = "awsRegion", value = var.region }]
  combined_cluster_autoscaler_set_values_list = concat(var.cluster_autoscaler_set_values_list, local.cluster_autoscaler_set_values_list_internal)

  # for sonarqube
  sonarqube_set_values_list_internal = [{ name = "ingress.hosts[0].name", value = "sonarqube\\.${var.domain_name}" }, { name = "ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname", value = "sonarqube\\.${var.domain_name}" }, { name = "ingress.tls[0].hosts[0]", value = "sonarqube\\.${var.domain_name}" }]
  combined_sonarqube_set_values_list = concat(var.sonarqube_set_values_list, local.sonarqube_set_values_list_internal)

}

module "vpc" {
  source                      = "./modules/VPC"
  app_name                    = var.app_name
  vpc_cidr_block              = var.vpc_cidr_block
  private_subnets_cidr_blocks = var.private_subnets_cidr_blocks
  public_subnets_cidr_blocks  = var.public_subnets_cidr_blocks
  availability_zones          = var.availability_zones
  cluster_name                = local.cluster_name
}

module "ecr" {
  source   = "./modules/ECR"
  app_name = "${local.cluster_name}-eks"
}

module "acm" {
  source            = "./modules/ACM"
  app_name          = var.app_name
  domain_name       = var.domain_name
  validation_method = var.validation_method
  key_algorithm     = var.key_algorithm
}

module "iam" {
  source            = "./modules/IAM"
  app_name          = var.app_name
  create_node_group = var.create_node_group
  create_fargate    = var.create_fargate
}

module "kms" {
  source   = "./modules/KMS"
  app_name = var.app_name
}

module "iam_lb_ingress_controller" {
  source                                        = "./modules/IAM_CONTROLLER"
  app_name                                      = var.app_name
  fetch_policy_from_repo                        = true
  controller_iam_policy_url                     = var.lbc_ingress_controller_iam_policy_url
  service_account_name                          = var.lb_ingress_controller_service_account_name
  name_space                                    = var.lb_ingress_controller_name_space
  iam_policy_row_data                           = null
  aws_iam_openid_connect_provider_arn           = module.iam_oidc_provider.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_arn_issuer_id = module.iam_oidc_provider.aws_iam_openid_connect_provider_arn_issuer_id
}

module "iam_external_dns_controller" {
  source                                        = "./modules/IAM_CONTROLLER"
  app_name                                      = var.app_name
  fetch_policy_from_repo                        = false
  controller_iam_policy_url                     = null
  service_account_name                          = var.external_dns_service_account_name
  name_space                                    = var.external_dns_namespace
  iam_policy_row_data                           = var.iam_policy_row_data
  aws_iam_openid_connect_provider_arn           = module.iam_oidc_provider.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_arn_issuer_id = module.iam_oidc_provider.aws_iam_openid_connect_provider_arn_issuer_id
}

module "iam_cluster_autoscaler" {
  source                                        = "./modules/IAM_CONTROLLER"
  app_name                                      = var.app_name
  fetch_policy_from_repo                        = false
  controller_iam_policy_url                     = null
  service_account_name                          = var.cluster_autoscaler_service_account_name
  name_space                                    = var.cluster_autoscaler_namespace
  iam_policy_row_data                           = var.cluster_autoscaler_iam_policy_row_data
  aws_iam_openid_connect_provider_arn           = module.iam_oidc_provider.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_arn_issuer_id = module.iam_oidc_provider.aws_iam_openid_connect_provider_arn_issuer_id
}

module "iam_ebs_csi" {
  source                                        = "./modules/IAM_CONTROLLER"
  app_name                                      = var.app_name
  fetch_policy_from_repo                        = true
  controller_iam_policy_url                     = var.iam_ebs_csi_iam_policy_url
  service_account_name                          = var.iam_ebs_csi_service_account_name
  name_space                                    = var.iam_ebs_csi_namespace
  iam_policy_row_data                           = null
  aws_iam_openid_connect_provider_arn           = module.iam_oidc_provider.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_arn_issuer_id = module.iam_oidc_provider.aws_iam_openid_connect_provider_arn_issuer_id
}

module "iam_oidc_provider" {
  source                                  = "./modules/IAM_OIDC_PROVIDER"
  eks_cluster_openid_connect_provider_url = module.eks.eks_cluster_openid_connect_provider_url
  cluster_name                            = module.eks.eks_cluster_id
  depends_on                              = [module.eks]
}

module "external_dns_controller" {
  source              = "./modules/CONTROLLER"
  controller_repo_url = var.external_dns_controller_repo_url
  chart_name          = var.external_dns_chart_name
  namespace           = var.external_dns_namespace
  set_values_list     = local.combined_external_dns_set_values_list
  depends_on          = [module.iam_external_dns_controller.controller_iam_role_arn, module.eks]
}

module "aws_lb_ingress_controller" {
  source              = "./modules/CONTROLLER"
  controller_repo_url = var.aws_lb__ingress_controller_repository_url
  chart_name          = var.aws_lb_ingress_controller_chart_name
  namespace           = var.lb_ingress_controller_name_space
  set_values_list     = local.combined_aws_lb_ingress_controller_set_values_list
  depends_on          = [module.iam_lb_ingress_controller.controller_iam_role_arn, module.eks]
}

# Cluster autoscaler for node group only, comment here if node group doesn't use!!!
module "cluster_autoscaler" {
  source              = "./modules/CONTROLLER"
  controller_repo_url = var.cluster_autoscaler_repo_url
  chart_name          = var.cluster_autoscaler_chart_name
  namespace           = var.cluster_autoscaler_namespace
  set_values_list     = local.combined_cluster_autoscaler_set_values_list
  depends_on          = [module.iam_cluster_autoscaler.controller_iam_role_arn, module.eks]
}

module "metric_server" {
  source              = "./modules/CONTROLLER"
  controller_repo_url = var.metric_server_repo_url
  chart_name          = var.metric_server_chart_name
  namespace           = var.metric_server_namespace
  set_values_list     = local.metric_set_values_list
  depends_on          = [module.eks]

}

module "eks_csi" {
  source                   = "./modules/EBS_CSI"
  ebs_addon_name           = var.ebs_addon_name
  cluster_name             = module.eks.eks_cluster_id
  service_account_role_arn = module.iam_ebs_csi.controller_iam_role_arn
  depends_on               = [module.iam_ebs_csi.controller_iam_role_policy_attach]
}


module "sonarqube" {
  source              = "./modules/CONTROLLER"
  controller_repo_url = var.sonarqube_repo_url
  chart_name          = var.sonarqube_chart_name
  namespace           = module.sonarqube_ns.namespace_name
  set_values_list     = local.combined_sonarqube_set_values_list
  depends_on          = [module.eks, module.sonarqube_ns]

}

# Create Cloudwatch agent and Flentbit agent for cloudwatch container insights and log
module "cw_metric_log_agent" {
  source                      = "./modules/CW_METRIC_LOG_AGENT"
  region                      = var.region
  cluster_name                = module.eks.eks_cluster_id
  cwa_flent_configmap_ns_name = module.amazon_cloudwatch_ns.namespace_name

  depends_on = [module.amazon_cloudwatch_ns]
}

# Install Vertical Pod Autoscaler via provisioner local exec
module "install_vpa" {
  source             = "./modules/VPA_INSTALL"
  cluster_name       = module.eks.eks_cluster_id
  region             = var.region
  git_clone_command  = var.git_clone_command
  install_vpa_path   = var.install_vpa_path
  removed_folder     = var.removed_folder
  uninstall_vpa_path = var.uninstall_vpa_path
  depends_on         = [module.eks, module.metric_server]
}

module "eks" {
  source                               = "./modules/EKS"
  cluster_name                         = local.cluster_name
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  cluster_service_ipv4_cidr            = var.cluster_service_ipv4_cidr
  eks_cluster_version                  = var.eks_cluster_version
  timeouts_delete_time                 = var.timeouts_delete_time

  key_arn              = module.kms.kms_key_arn
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  subnet_ids           = local.subnet_ids
  depends_on           = [module.iam.eks_AmazonEKSClusterPolicy_id, module.iam.eks_AmazonEKSVPCResourceController_id, module.kms, module.vpc]
}

# Create eks node group in private subnet---------------
module "eks_node_group_private" {
  source                         = "./modules/NODE_GROUP"
  cluster_name                   = module.eks.eks_cluster_id
  node_group_visibility          = var.node_group_visibility
  node_group_desired_size        = var.node_group_desired_size
  node_group_max_size            = var.node_group_max_size
  node_group_min_size            = var.node_group_min_size
  max_unavailable_work_node      = var.max_unavailable_work_node
  ami_type                       = var.ami_type
  capacity_type                  = var.capacity_type
  disk_size                      = var.disk_size
  instance_types                 = var.instance_types
  eks_cluster_version            = var.eks_cluster_version
  private_remote_access_key_name = var.private_remote_access_key_name

  eks_nodegroup_role_arn = module.iam.eks_nodegroup_role_arn
  subnet_ids             = [for private_subnet in module.vpc.private_subnets : private_subnet.id]
  depends_on             = [module.iam.eks_AmazonEKSWorkerNodePolicy_id, module.iam.eks_AmazonEKS_CNI_Policy_id, module.iam.eks_AmazonEC2ContainerRegistryReadOnly_id]
}

# Configurate aws-auth

module "aws_auth" {
  source                 = "./modules/AWS_AUTH"
  nodegroup_iam_role_arn = module.iam.eks_nodegroup_role_arn
  aws_iam_users          = var.aws_iam_users
  depends_on             = [module.eks, module.eks_node_group_private]
}

# Create uat and pro ns---------------
module "offerripple_ns_uat" {
  source                 = "./modules/NS"
  created_namespace_name = var.ns_name_offerripple_uat
  depends_on             = [module.eks]
}

module "offerripple_ns_pro" {
  source                 = "./modules/NS"
  created_namespace_name = var.ns_name_offerripple_pro
  depends_on             = [module.eks]
}

module "amazon_cloudwatch_ns" {
  source                 = "./modules/NS"
  created_namespace_name = var.ns_name_amazon_cloudwatch
  depends_on             = [module.eks]
}
module "sonarqube_ns" {
  source                 = "./modules/NS"
  created_namespace_name = var.ns_name_sonarqube
  depends_on             = [module.eks]
}
# # ----------------------------------The fargated created below will be available when use fargate only ------------
# # Fargate-UAT
# module "fargate_ns_uat" {
#   source             = "./modules/FARGATE"
#   cluster_name       = module.eks.eks_cluster_id
#   namespace_name     = module.offerripple_ns_uat.namespace_name
#   private_subnet_ids = [for private_subnet in module.vpc.private_subnets : private_subnet.id]

#   pod_execution_role_arn = module.iam.fargate_profile_role_arn
#   depends_on             = [module.iam.fargate_profile_role_arn, module.eks]
# }

# # Fargate-Pro environment 
# module "fargate_ns_pro" {
#   source             = "./modules/FARGATE"
#   cluster_name       = module.eks.eks_cluster_id
#   namespace_name     = module.offerripple_ns_pro.namespace_name
#   private_subnet_ids = [for private_subnet in module.vpc.private_subnets : private_subnet.id]

#   pod_execution_role_arn = module.iam.fargate_profile_role_arn
#   depends_on             = [module.iam.fargate_profile_role_arn, module.eks]
# }

# # Fargate profile for default namespace
# module "fargate_ns_default" {
#   source             = "./modules/FARGATE"
#   cluster_name       = module.eks.eks_cluster_id
#   namespace_name     = "default"
#   private_subnet_ids = [for private_subnet in module.vpc.private_subnets : private_subnet.id]

#   pod_execution_role_arn = module.iam.fargate_profile_role_arn
#   depends_on             = [module.iam.fargate_profile_role_arn, module.eks]
# }

# # Fargate profile for kube-system namespace

# module "fargate_ns_kube_system" {
#   source             = "./modules/FARGATE"
#   cluster_name       = module.eks.eks_cluster_id
#   namespace_name     = "kube-system"
#   private_subnet_ids = [for private_subnet in module.vpc.private_subnets : private_subnet.id]

#   pod_execution_role_arn = module.iam.fargate_profile_role_arn
#   depends_on             = [module.iam.fargate_profile_role_arn, module.eks]
# }

# # Fargate profile for amazon-cloudwatch
# module "fargate_ns_amazon_cloudwatch" {
#   source             = "./modules/FARGATE"
#   cluster_name       = module.eks.eks_cluster_id
#   namespace_name     = module.amazon_cloudwatch_ns.namespace_name
#   private_subnet_ids = [for private_subnet in module.vpc.private_subnets : private_subnet.id]

#   pod_execution_role_arn = module.iam.fargate_profile_role_arn
#   depends_on             = [module.iam.fargate_profile_role_arn, module.eks]
# }

# # Patch the coreDNS's computer-type on annomations and restart when coreDNS run fargate only[no node group created on cluster]

# resource "null_resource" "patch_restart_coredns" {
#   triggers = {
#     cluster_id = module.eks.eks_cluster_id
#     fargate_id = module.fargate_ns_kube_system.fargate_id
#   }
#   provisioner "local-exec" {
#     command = <<EOF
#     kubectl patch deployment coredns \
#     -n kube-system \
#     --type json \
#     -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'
#     kubectl rollout restart -n kube-system deployment coredns
#     EOF
#   }
#   depends_on = [module.install_vpa, module.fargate_ns_kube_system]
# }

# # -----------------------------------------------The above are for fargate only --------


