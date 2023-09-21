# Resource: Helm Release 
resource "helm_release" "controller" {
  name = "${var.chart_name}-release"

  repository = var.controller_repo_url
  chart      = var.chart_name

  namespace = var.namespace
  timeout   = 600

  dynamic "set" {
    for_each = var.set_values_list
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}