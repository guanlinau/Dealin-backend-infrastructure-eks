
variable "app_name" {
  description = "The name of the app"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "The name of the cluster"
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