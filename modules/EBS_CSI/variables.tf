variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = null
}

variable "service_account_role_arn" {
  description = "The arn of the service account"
  type        = string
  default     = null
}
variable "ebs_addon_name" {
  description = "The name of the ebs_addon_name"
  type        = string
  default     = null
}