variable "cwa_flent_configmap_ns_name" {
  description = "The namespace name of the cwa configmap want to be placed"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = null
}

variable "region" {
  description = "The region to be deployed."
  type        = string
  default     = "ap-southeast-2"
}