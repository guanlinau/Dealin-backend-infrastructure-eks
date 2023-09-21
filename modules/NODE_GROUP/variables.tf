variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = null
}

variable "eks_nodegroup_role_arn" {
  description = "The arn of the eks node group role"
  type        = string
  default     = null

}

variable "subnet_ids" {
  description = "The ids of the subnet where the node group will be launched"
  type        = list(string)
  default     = null
}
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

variable "eks_cluster_version" {
  description = "The ami version of the eks node group"
  type        = string
  default     = null
}

variable "private_remote_access_key_name" {
  description = "The private remote access key for node group"
  type        = string
  default     = null
}