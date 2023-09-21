variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = null
}

variable "eks_cluster_role_arn" {
  description = "The arn of eks cluster role"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "The subnet_ids"
  type        = list(string)
  default     = null
}


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

variable "cluster_service_ipv4_cidr" {
  description = "service ipv4 cidr for the kubernetes cluster"
  type        = string
  default     = null
}

variable "eks_cluster_version" {
  description = "Kubernetes minor version to use for the EKS cluster (for example 1.21)"
  type        = string
  default     = null
}

variable "timeouts_delete_time" {
  description = "How long the cluster will be deleted after it appears time out"
  type        = string
  default     = "15m"
}

variable "key_arn" {
  description = "The arn of the key management service"
  type        = string
  default     = null
}