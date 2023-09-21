
variable "app_name" {
  description = "The name of the app"
  type        = string
  default     = null
}

variable "create_node_group" {
  description = "Whether create node group or not"
  type        = bool
  default     = false
}

variable "aws_iam_openid_connect_provider_arn" {
  description = "The arn of aws_iam_openid_connect_provider"
  type        = string
  default     = null
}
variable "aws_iam_openid_connect_provider_arn_issuer_id" {
  description = "The id of aws_iam_openid_connect_provider_arn_issuer"
  type        = string
  default     = null
}

# For fargate
variable "create_fargate" {
  description = "Create a fargate profile role or not."
  type        = bool
  default     = false
}