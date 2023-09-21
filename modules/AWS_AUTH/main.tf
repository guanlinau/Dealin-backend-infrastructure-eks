
resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<-YAML
      - rolearn: ${var.nodegroup_iam_role_arn}
        username: system:node:{{EC2PrivateDNSName}}
        groups:
          - system:bootstrappers
          - system:nodes
    YAML

    mapUsers = <<-YAML
     ${join("\n", [for user in var.aws_iam_users : "- userarn: arn:aws:iam::${user.aws_account_id}:user/${user.username}\n  username: ${user.username}\n  groups:\n    - ${user.group}"])}
    YAML
  }
  force = true
}