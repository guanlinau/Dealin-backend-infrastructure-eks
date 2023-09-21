# Create iam role with policy for kubernetes contorller interacted with AWS
locals {
  fetched_controller_iam_policy_outcome = var.fetch_policy_from_repo == true ? data.http.fetched_controller_iam_policy[0].response_body : null
  controller_iam_role_name              = var.service_account_name
}
# Datasource:  Controller IAM Policy get from GIT Repo (latest)
data "http" "fetched_controller_iam_policy" {
  count = var.fetch_policy_from_repo == true ? 1 : 0
  url   = var.controller_iam_policy_url

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

# Resource: Create IAM Role 
resource "aws_iam_role" "controller_iam_role" {
  name = "${var.app_name}-${local.controller_iam_role_name}-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${var.aws_iam_openid_connect_provider_arn}"
        }
        Condition = {
          StringEquals = {
            "${var.aws_iam_openid_connect_provider_arn_issuer_id}:aud" : "sts.amazonaws.com",
            "${var.aws_iam_openid_connect_provider_arn_issuer_id}:sub" : "system:serviceaccount:${var.name_space}:${var.service_account_name}"
          }
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.app_name}-${local.controller_iam_role_name}-IAMPolicy"
  }
}
# Resource: Create AWS Controller IAM Policy 
resource "aws_iam_policy" "controller_iam_policy" {
  name        = "${var.app_name}-${local.controller_iam_role_name}-IAMPolicy"
  path        = "/"
  description = "${local.controller_iam_role_name} IAM Policy"
  policy      = var.fetch_policy_from_repo == true ? local.fetched_controller_iam_policy_outcome : jsonencode(var.iam_policy_row_data)
  depends_on  = [local.fetched_controller_iam_policy_outcome]
}

# Associate Load Balanacer Controller IAM Policy to  IAM Role
resource "aws_iam_role_policy_attachment" "controller_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.controller_iam_policy.arn
  role       = aws_iam_role.controller_iam_role.name
  depends_on = [aws_iam_policy.controller_iam_policy, aws_iam_role.controller_iam_role]
}
