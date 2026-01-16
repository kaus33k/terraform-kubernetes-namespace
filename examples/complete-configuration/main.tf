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

# Example 1: Production namespace with all features
module "production_namespace" {
  source  = "tf-kubernetes-iaac/namespace/kubernetes"
  version = "2.0.0"

  name = "production-app"

  labels = {
    environment     = "production"
    team            = "application"
    tier            = "application"
    cost-center     = "engineering"
    compliance      = "pci-dss"
    backup-policy   = "daily"
    managed-by      = "terraform"
    release-channel = "stable"
  }

  annotations = {
    "description"                 = "Production application deployment namespace"
    "owner"                       = "app-team@example.com"
    "slack-channel"               = "#prod-alerts"
    "runbook"                     = "https://wiki.example.com/runbooks/prod-app"
    "backup.velero.io/backup"     = "true"
    "prometheus.io/scrape"        = "true"
    "policy.kyverno.io/enforce"   = "true"
  }

  # Service account configuration
  create_custom_default_service_account = true
  automount_service_account_token       = true
  create_token                          = true

  # Image pull secrets for private registries
  image_pull_secrets = [
    "docker-registry-prod",
    "ecr-prod-credential"
  ]

  # Mountable secrets for pod volume mounts
  mountable_secrets = [
    "docker-registry-prod",
    "app-config-secret",
    "tls-certs"
  ]

  # Delete timeout for graceful shutdown
  delete_timeouts = "10m"
}

# Example 2: Development namespace with generated name
module "dev_namespace" {
  source  = "tf-kubernetes-iaac/namespace/kubernetes"
  version = "2.0.0"

  generate_name = true
  name_prefix   = "dev-app"

  labels = {
    environment     = "development"
    team            = "application"
    tier            = "application"
    managed-by      = "terraform"
    release-channel = "nightly"
  }

  annotations = {
    "description"              = "Development environment for application team"
    "owner"                    = "dev-lead@example.com"
    "slack-channel"            = "#dev-notifications"
    "documentation"            = "https://wiki.example.com/dev-guide"
    "backup.velero.io/backup"  = "false"
  }

  # Simpler configuration for dev
  create_custom_default_service_account = true
  automount_service_account_token       = true
  create_token                          = true

  delete_timeouts = "5m"
}

# Example 3: Staging namespace with specific service account setup
module "staging_namespace" {
  source  = "tf-kubernetes-iaac/namespace/kubernetes"
  version = "2.0.0"

  name = "staging-app"

  labels = {
    environment     = "staging"
    team            = "qa-engineering"
    tier            = "application"
    cost-center     = "qa"
    managed-by      = "terraform"
    release-channel = "beta"
  }

  annotations = {
    "description"              = "Staging environment for pre-production testing"
    "owner"                    = "qa-lead@example.com"
    "slack-channel"            = "#staging-alerts"
    "backup.velero.io/backup"  = "true"
    "sso.enabled"              = "true"
    "network-policy.enabled"   = "true"
  }

  create_custom_default_service_account = true
  automount_service_account_token       = false
  create_token                          = true

  image_pull_secrets = [
    "docker-registry-staging",
    "ecr-staging-credential"
  ]

  mountable_secrets = [
    "docker-registry-staging",
    "staging-config"
  ]

  delete_timeouts = "7m"
}

# Outputs for all namespaces
output "production_namespace" {
  description = "Production namespace details"
  value = {
    name           = module.production_namespace.namespace_name
    uid            = module.production_namespace.namespace_uid
    method         = module.production_namespace.namespace_generation_method
    labels         = module.production_namespace.namespace_labels
    annotations    = module.production_namespace.namespace_annotations
  }
}

output "dev_namespace" {
  description = "Development namespace details"
  value = {
    name           = module.dev_namespace.namespace_name
    uid            = module.dev_namespace.namespace_uid
    method         = module.dev_namespace.namespace_generation_method
    labels         = module.dev_namespace.namespace_labels
    annotations    = module.dev_namespace.namespace_annotations
  }
}

output "staging_namespace" {
  description = "Staging namespace details"
  value = {
    name           = module.staging_namespace.namespace_name
    uid            = module.staging_namespace.namespace_uid
    method         = module.staging_namespace.namespace_generation_method
    labels         = module.staging_namespace.namespace_labels
    annotations    = module.staging_namespace.namespace_annotations
  }
}
