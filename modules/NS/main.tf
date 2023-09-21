resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    annotations = {
      name = "${var.created_namespace_name}"
    }

    labels = {
      mylabel = "${var.created_namespace_name}"
    }

    name = var.created_namespace_name
  }
}