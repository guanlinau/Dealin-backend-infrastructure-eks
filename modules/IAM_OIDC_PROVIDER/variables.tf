variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = null
}

variable "eks_cluster_openid_connect_provider_url" {
  description = "eks_cluster_openid_connect_provider_url"
  type        = string
  default     = null
}