variable "aws_iam_users" {
  description = "List of IAM users to map to the cluster"
  type = list(object({
    aws_account_id = string
    username       = string
    group          = string
  }))
  default = []
}
variable "nodegroup_iam_role_arn" {
  description = "The arn of the nodegroup"
}