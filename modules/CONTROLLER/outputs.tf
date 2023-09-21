output "controller_helm_metadata" {
  value = helm_release.controller.metadata
}
output "controller_status" {
  value = helm_release.controller.status
}