# Use this data source to lookup information about the current AWS partition in which Terraform is working
data "aws_partition" "current" {}

#Get the thumprint 
data "tls_certificate" "thumbprint" {
  url = var.eks_cluster_openid_connect_provider_url
}

# Resource: AWS IAM Open ID Connect Provider
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [data.tls_certificate.thumbprint.certificates.0.sha1_fingerprint]
  # thumbprint_list = ["9E99A48A9960B14926BB7F3B02E22DA2B0AB7280"]
  url = var.eks_cluster_openid_connect_provider_url
  tags = {
    Name = "${var.cluster_name}-identify-provider"
  }
}
