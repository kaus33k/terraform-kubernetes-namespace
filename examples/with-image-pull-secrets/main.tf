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

module "namespace_with_image_pull_secrets" {
  source  = "tf-kubernetes-iaac/namespace/kubernetes"
  version = "2.0.0"

  name = "private-registry"

  labels = {
    environment = "production"
    managed-by  = "terraform"
  }

  annotations = {
    "description" = "Namespace for applications using private container registries"
  }

  # Enable custom default service account
  create_custom_default_service_account = true
  
  # List of image pull secrets for the default service account
  # These must be pre-existing Kubernetes secrets in the cluster
  image_pull_secrets = [
    "docker-registry-credential",
    "private-ecr-credential",
    "ghcr-credential"
  ]

  # Mountable secrets that pods in this namespace can reference
  mountable_secrets = [
    "docker-registry-credential",
    "private-ecr-credential"
  ]

  # Enable automatic token mounting
  automount_service_account_token = true
  
  # Create the service account token secret
  create_token = true
}

output "namespace_name" {
  description = "The name of the created namespace"
  value       = module.namespace_with_image_pull_secrets.namespace_name
}

# Display configured image pull secrets for reference
output "image_pull_secrets_configured" {
  description = "Image pull secrets available to the default service account"
  value = [
    "docker-registry-credential",
    "private-ecr-credential",
    "ghcr-credential"
  ]
}
