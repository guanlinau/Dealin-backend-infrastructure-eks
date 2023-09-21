terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.10.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~>3.3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.21.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
  required_version = ">=1.4.5"
}

# Terraform AWS Provider Block
provider "aws" {
  region = var.region
  # shared_config_files      = ["~/.aws/config"]
  # shared_credentials_files = ["~/.aws/credentials"]
  # profile                  = "default"
}

# Terraform HTTP Provider Block
provider "http" {
  # Configuration options
}

# Terraform tls Provider Block
provider "tls" {
  # Configuration options
}

# Terraform helm Provider Block
provider "helm" {
  kubernetes {
    # config_path            = "~/.kube/config"
    host                   = module.eks.eks_cluster_api_endpoint
    cluster_ca_certificate = base64decode(module.eks.eks_cluster_kubeconfig_certificate_authority_data)
    token                  = module.eks.eks_cluster_token
  }
}

# Terraform Kubernetes Provider Block
provider "kubernetes" {
  # config_path            = "~/.kube/config"
  host                   = module.eks.eks_cluster_api_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_cluster_kubeconfig_certificate_authority_data)
  token                  = module.eks.eks_cluster_token
}
# Terraform kubectl Provider Block
provider "kubectl" {
  # config_path            = "~/.kube/config"
  host                   = module.eks.eks_cluster_api_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_cluster_kubeconfig_certificate_authority_data)
  token                  = module.eks.eks_cluster_token
}