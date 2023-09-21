variable "app_name" {
  description = "The name of the app"
  type        = string
  default     = null
}

variable "fetch_policy_from_repo" {
  description = "Fetch the latest policy from offical git repo via http provider."
  type        = bool
  default     = false
}

variable "controller_iam_policy_url" {
  description = "The url of controller_iam_policy_url"
  type        = string
  default     = null
}

variable "service_account_name" {
  description = "Name of the awsloadblancer ingress controller service account."
  type        = string
  default     = null
}
variable "name_space" {
  description = "The name space you want to deploy the pod."
  type        = string
  default     = "kube-system"
}

variable "iam_policy_row_data" {
  description = "The detailed data of the iam policy"
  type        = any
  default     = null
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
