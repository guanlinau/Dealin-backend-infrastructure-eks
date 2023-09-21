variable "region" {
  description = "The region want to deploy"
  type        = string
  default     = "ap-southeast-2"
}

#For vpc
variable "app_name" {
  description = "The name of the app"
  type        = string
  default     = null
}

variable "vpc_cidr_block" {
  description = "The vp cidr block range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets_cidr_blocks" {
  description = "The private subnets cidr block range"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}
variable "public_subnets_cidr_blocks" {
  description = "The public subnets cidr block range"
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

variable "availability_zones" {
  description = "The azs lists"
  type        = list(string)
  default     = ["ap-southeast-2a"]
}

# For Amazon Certificate manager
variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = null
}

variable "validation_method" {
  description = "Which method to use for validation. DNS or EMAIL are valid, NONE can be used for certifications imported outside"
  type        = string
  default     = "DNS"

  validation {
    condition     = contains(["DNS", "EMAIL", "NONE"], var.validation_method)
    error_message = "Valid values are DNS, EMAIL or NONE"
  }
}

variable "key_algorithm" {
  description = "Specifies the algorithm of the public and private key pair that your Amazon issued certificate uses to encrypt data. 'RSA_2048', 'EC_prime256v1' or 'EC_secp384r1' are valid"
  type        = string
  default     = "RSA_2048"

  validation {
    condition     = contains(["RSA_2048", "EC_prime256v1", "EC_secp384r1"], var.key_algorithm)
    error_message = "Valid values are 'RSA_2048', 'EC_prime256v1' or 'EC_secp384r1'"
  }
}

#For IAM
variable "create_node_group" {
  description = "Whether create node group or not"
  type        = bool
  default     = false
}

variable "create_fargate" {
  description = "Create a fargate profile role or not."
  type        = bool
  default     = false
}

#For IAM aws load balancer ingress controller

variable "lbc_ingress_controller_iam_policy_url" {
  description = "The url of lbc_ingress_controller_iam_policy_url"
  type        = string
  default     = null
}

variable "lb_ingress_controller_service_account_name" {
  description = "Name of the awsloadblancer ingress controller service account."
  type        = string
  default     = null
}

variable "lb_ingress_controller_name_space" {
  description = "The name space you want to deploy the pod."
  type        = string
  default     = "kube-system"
}

# For iam ebs csi 
variable "iam_ebs_csi_iam_policy_url" {
  description = "The url of the ebs_csi_iam_policy_url"
  type        = string
  default     = null
}
variable "iam_ebs_csi_service_account_name" {
  description = "Name of the awsloadblancer ingress controller service account."
  type        = string
  default     = null
}

variable "iam_ebs_csi_namespace" {
  description = "The name space you want to deploy the pod."
  type        = string
  default     = "kube-system"
}

# For IAM external dns controller
variable "external_dns_namespace" {
  description = "The namespace of external_dns"
  type        = string
  default     = "default"
}

variable "external_dns_service_account_name" {
  description = "The name of the external_service_account_name"
  type        = string
  default     = null
}

variable "iam_policy_row_data" {
  description = "The detailed data of the iam policy"
  type        = any
  default     = null
}

# For IAM cluster autoscaler
variable "cluster_autoscaler_namespace" {
  description = "The namespace of external_dns"
  type        = string
  default     = "default"
}

variable "cluster_autoscaler_service_account_name" {
  description = "The name of the cluster_autoscaler_service_account_name"
  type        = string
  default     = null
}

variable "cluster_autoscaler_iam_policy_row_data" {
  description = "The detailed data of the iam policy"
  type        = any
  default     = null
}

#For EKS 
variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. When it's set to `false` ensure to have a proper private access with `cluster_endpoint_private_access = true`."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "eks_cluster_version" {
  description = "Kubernetes minor version to use for the EKS cluster (for example 1.21)"
  type        = string
  default     = null
}

variable "cluster_service_ipv4_cidr" {
  description = "service ipv4 cidr for the kubernetes cluster"
  type        = string
  default     = null
}

variable "timeouts_delete_time" {
  description = "How long the cluster will be deleted after it appears time out"
  type        = string
  default     = "15m"
}

# For node group

variable "node_group_visibility" {
  description = "The visibility of the node group, whether you want to put the node group in public subnet or private subnet."
  type        = string
  default     = null
}

variable "node_group_desired_size" {
  description = "The desired size of the node group"
  type        = number
  default     = null
}

variable "node_group_max_size" {
  description = "The max size of the node group"
  type        = number
  default     = null
}

variable "node_group_min_size" {
  description = "The min size of the node group"
  type        = number
  default     = null
}

variable "max_unavailable_work_node" {
  description = "the max unavailable work node during updation"
  type        = number
  default     = 1
}

variable "ami_type" {
  description = "The ami type that the node group will use, see details: https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType"
  type        = string
  default     = null
}

variable "capacity_type" {
  description = "The type of capacity associated with the node group, such as ON_DEMAND or SPOT"
  type        = string
  default     = "SPOT"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "Valid values are ON_DEMAND or SPOT"
  }
}

variable "disk_size" {
  description = "The disk size in GiB for work nodes"
  type        = number
  default     = 20
}

variable "instance_types" {
  description = "The type of instance used by node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "private_remote_access_key_name" {
  description = "The private remote access key for node group"
  type        = string
  default     = null
}

# For aws ld ingress controller helm
variable "aws_lb__ingress_controller_repository_url" {
  description = "The url of the controller repository "
  type        = string
  default     = null
}
variable "aws_lb_ingress_controller_chart_name" {
  description = "The chart_name you want to use"
  type        = string
  default     = null
}
variable "aws_lb_ingress_controller_set_values_list" {
  description = "The lb ingress controller values list should be overwrited into the values.yaml of helm chart."
  type = list(object({
    name  = string
    value = string
  }))
  default = null
}

# For external dns controller
variable "external_dns_controller_repo_url" {
  description = "The repo url of external dns controller repo"
  type        = string
  default     = null
}
variable "external_dns_chart_name" {
  description = "The external dns chart name in the repo to be used."
  type        = string
  default     = null
}

variable "external_dns_set_values_list" {
  description = "The external dns values list should be overwrited into the values.yaml of helm chart."
  type = list(object({
    name  = string
    value = string
  }))
  default = null
}
#For metric server
variable "metric_server_repo_url" {
  description = "The repo url of metric_server_repo"
  type        = string
  default     = null
}
variable "metric_server_chart_name" {
  description = "The metric_server chart name in the repo to be used."
  type        = string
  default     = null
}

variable "metric_set_values_list" {
  description = "The values list should be overwrited into the values.yaml of helm chart."
  type = list(object({
    name  = string
    value = string
  }))
}

variable "metric_server_namespace" {
  description = "The namespace of metric_server"
  type        = string
  default     = "default"
}

# For sonarqube
variable "sonarqube_repo_url" {
  description = "The repo url of metric_server_repo"
  type        = string
  default     = null
}
variable "sonarqube_chart_name" {
  description = "The metric_server chart name in the repo to be used."
  type        = string
  default     = null
}

variable "sonarqube_set_values_list" {
  description = "The values list should be overwrited into the values.yaml of helm chart."
  type = list(object({
    name  = string
    value = string
  }))
}


# For cluster autoscler
variable "cluster_autoscaler_repo_url" {
  description = "The repo url of cluster_autoscaler_repo"
  type        = string
  default     = null
}

variable "cluster_autoscaler_chart_name" {
  description = "The cluster autoscaler chart name in the repo to be used."
  type        = string
  default     = null
}

variable "cluster_autoscaler_set_values_list" {
  description = "The external dns values list should be overwrited into the values.yaml of helm chart."
  type = list(object({
    name  = string
    value = string
  }))
  default = null
}
# For kubernetes
variable "ns_name_offerripple_uat" {
  description = "The name of the namespace you want to create."
  type        = string
  default     = "default"
}

variable "ns_name_offerripple_pro" {
  description = "The name of the namespace you want to create."
  type        = string
  default     = "default"
}

variable "ns_name_amazon_cloudwatch" {
  description = "The name of the namespace you want to create."
  type        = string
  default     = "default"
}
variable "ns_name_sonarqube" {
  description = "The namespace of sonarqube"
  type        = string
  default     = "default"
}

# For install vertical pod autoscaler
variable "git_clone_command" {
  description = "The repo want to git clone here."
  type        = string
  default     = null

}

variable "install_vpa_path" {
  description = "the install_vpa_path"
  type        = string
  default     = null
}

variable "removed_folder" {
  description = "The folder want to remove."
  default     = null
}

variable "uninstall_vpa_path" {
  description = "uninstall_vpa_path"
  type        = string
  default     = null

}

# For aws auth

variable "aws_iam_users" {
  description = "List of IAM users to map to the cluster"
  type = list(object({
    aws_account_id = string
    username       = string
    group          = string
  }))
  default = []
}

# For ebs-addon
variable "ebs_addon_name" {
  description = "The name of the ebs_addon_name"
  type        = string
  default     = null
}