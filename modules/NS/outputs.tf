output "name_space_metadata" {
  value = kubernetes_namespace_v1.namespace.metadata
}

output "namespace_name" {
  value = kubernetes_namespace_v1.namespace.metadata[0].name
}
