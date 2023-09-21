output "aws_iam_openid_connect_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "aws_iam_openid_connect_provider_arn_issuer_id" {
  value = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)
}