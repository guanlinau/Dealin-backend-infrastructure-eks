variable "cluster_name" {
  description = "The name of the cluster."
  type        = string
  default     = null

}

variable "pod_execution_role_arn" {
  description = "The fargate pod_execution_role_arn."
  type        = string
  default     = null
}

variable "private_subnet_ids" {
  description = "The private ids of the subnet that fargate can be deployed."
  type        = list(string)
  default     = null
}

variable "namespace_name" {
  description = "The name of the namespace."
  type        = string
  default     = null
}
variable "fargate_selector_labels_pair" {
  description = "The key_value map of Kubernetes labels for selection"
  type        = map(string)
  default     = null
}