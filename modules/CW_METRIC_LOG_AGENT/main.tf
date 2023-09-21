terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
  required_version = ">=1.4.5"
}

# Create cloudwatch agent
# ------------------------
# Implement Cloudwatch agent: Service Account, ClusteRole, ClusterRoleBinding in K8s cluster
resource "kubectl_manifest" "cwagent_serviceaccount" {
  yaml_body = file("${path.module}/cwagent_serviceaccount.yaml")
}
resource "kubectl_manifest" "cwagent_clusterole" {
  yaml_body  = file("${path.module}/cwagent_clusterrole.yaml")
  depends_on = [kubectl_manifest.cwagent_serviceaccount]
}
resource "kubectl_manifest" "cwagent_clusterrolebinding" {
  yaml_body  = file("${path.module}/cwagent_clusterrolebinding.yaml")
  depends_on = [kubectl_manifest.cwagent_clusterole]
}

# Implementation of Cloudwatch agent comfigmap
resource "kubernetes_config_map_v1" "cwagentconfig_configmap" {
  metadata {
    name      = "cwagentconfig"
    namespace = var.cwa_flent_configmap_ns_name
  }
  data = {
    "cwagentconfig.json" = jsonencode({
      "logs" : {
        "metrics_collected" : {
          "kubernetes" : {
            # "cluster_name" : var.cluster_name
            "metrics_collection_interval" : 60
          }
        },
        "force_flush_interval" : 5
      }
      "metrics" : {
        "metrics_collected" : {
          "statsd" : {
            "service_address" : ":8125"
          }
        }
      }
    })
  }
}

# Deploy Cloudwatch agent deamonset
resource "kubectl_manifest" "cwagent_daemonset" {
  yaml_body  = file("${path.module}/cwagent_daemonset.yaml")
  depends_on = [kubernetes_config_map_v1.cwagentconfig_configmap]
}

# Create Fluent bit agent
#-------------------------
# Resource: FluentBit Agent cluster info ConfigMap
resource "kubernetes_config_map_v1" "fluentbit_cluster_info_configmap" {
  metadata {
    name      = "fluent-bit-cluster-info"
    namespace = var.cwa_flent_configmap_ns_name
  }
  data = {
    "cluster.name" = var.cluster_name
    "http.port"    = "2020"
    "http.server"  = "On"
    "logs.region"  = var.region
    "read.head"    = "Off"
    "read.tail"    = "On"
  }
}

# Resource: kubectl_manifest which will create k8s Resources from the URL specified in above datasource
resource "kubectl_manifest" "fluent_bit_serviceaccount" {
  yaml_body = file("${path.module}/fluent_bit_serviceaccount.yaml")
}

resource "kubectl_manifest" "fluent_bit_clusterrole" {
  yaml_body  = file("${path.module}/fluent_bit_clusterrole.yaml")
  depends_on = [kubectl_manifest.fluent_bit_serviceaccount]
}

resource "kubectl_manifest" "fluent_bit_clusterrolebinding" {
  yaml_body  = file("${path.module}/fluent_bit_clusterrolebinding.yaml")
  depends_on = [kubectl_manifest.fluent_bit_clusterrole]
}
resource "kubectl_manifest" "fluent_bit_configmap" {
  yaml_body  = file("${path.module}/fluent_bit_configmap.yaml")
  depends_on = [kubectl_manifest.fluent_bit_clusterrolebinding]
}
resource "kubectl_manifest" "fluent_bit_damonset" {
  yaml_body = file("${path.module}/fluent_bit_damonset.yaml")

  depends_on = [
    kubernetes_config_map_v1.fluentbit_cluster_info_configmap,
    kubectl_manifest.fluent_bit_configmap,
    kubectl_manifest.cwagent_daemonset
  ]
}