
output "eks_cluster_id_name" {
  value = module.eks.eks_cluster_id
}

output "eks_cluster_api_endpoint" {
  value = module.eks.eks_cluster_api_endpoint
}

output "eks_ecr_repo" {
  value = module.ecr.ecr_repo_url
}

# output "lb_ingress_controller_helm_metadata" {
#   value = module.aws_lb_ingress_controller.controller_helm_metadata
# }

# output "lb_ingress_controller_status" {
#   value = module.aws_lb_ingress_controller.controller_status
# }
# output "external_dns_controller_helm_metadata" {
#   value = module.external_dns_controller.controller_helm_metadata
# }

# output "external_dns_controller_status" {
#   value = module.external_dns_controller.controller_status
# }

# output "cluster_autoscaler_helm_metadata" {
#   value = module.cluster_autoscaler.controller_helm_metadata
# }
# output "cluster_autoscaler_status" {
#   value = module.cluster_autoscaler.controller_status
# }

# output "metric_server_helm_metadata" {
#   value = module.metric_server.controller_helm_metadata
# }
output "metric_server_status" {
  value = module.metric_server.controller_status
}
