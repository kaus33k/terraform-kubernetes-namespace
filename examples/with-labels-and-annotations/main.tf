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

module "namespace_with_metadata" {
  source  = "tf-kubernetes-iaac/namespace/kubernetes"
  version = "2.0.0"

  name = "observability"

  # Comprehensive labeling for organization and filtering
  labels = {
    environment    = "production"
    team           = "platform-engineering"
    cost-center    = "infrastructure"
    managed-by     = "terraform"
    backup-policy  = "weekly"
    compliance     = "true"
  }

  # Annotations for operational metadata
  annotations = {
    "description"              = "Namespace for monitoring, logging, and observability stack"
    "owner"                    = "platform-team@example.com"
    "backup.velero.io/backup"  = "true"
    "notification.slack"       = "platform-alerts"
    "documentation"            = "https://wiki.example.com/observability"
    "created-date"             = "2024-01-16"
  }
}

output "namespace_name" {
  description = "The name of the created namespace"
  value       = module.namespace_with_metadata.namespace_name
}

output "namespace_labels" {
  description = "Labels applied to the namespace"
  value       = module.namespace_with_metadata.namespace_labels
}

output "namespace_annotations" {
  description = "Annotations applied to the namespace"
  value       = module.namespace_with_metadata.namespace_annotations
}
