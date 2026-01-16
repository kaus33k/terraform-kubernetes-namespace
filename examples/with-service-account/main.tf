terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "namespace_with_sa" {
  source  = "tf-kubernetes-iaac/namespace/kubernetes"
  version = "2.0.0"

  name = "backend-services"

  labels = {
    environment = "production"
    managed-by  = "terraform"
  }

  annotations = {
    "team" = "backend"
  }

  # Enable custom default service account creation
  create_custom_default_service_account = true
  
  # Allow service account token to be mounted in pods
  automount_service_account_token = true
  
  # Create the service account token secret (required for K8s >=1.24)
  create_token = true
}

output "namespace_name" {
  description = "The name of the created namespace"
  value       = module.namespace_with_sa.namespace_name
}

output "service_account_namespace" {
  description = "The namespace where the service account is created"
  value       = module.namespace_with_sa.namespace_name
}
