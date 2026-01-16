# Complete Configuration Example

This is a comprehensive example demonstrating multiple namespace configurations with all available features across different environments (Production, Development, and Staging).

## Usage

```bash
cd complete-configuration
terraform init
terraform plan
terraform apply
```

## What This Example Creates

Three fully configured Kubernetes namespaces:

### 1. Production Namespace (`production-app`)
- **Type**: Explicit namespace name
- **Features**: All features enabled
- **Purpose**: Production application workloads
- **Characteristics**:
  - PCI-DSS compliance enabled
  - Daily backup policy
  - Service account with token
  - Multiple image pull secrets
  - Longer delete timeout (10m)
  - Prometheus scraping enabled
  - Kyverno policy enforcement

### 2. Development Namespace (`dev-app-*`)
- **Type**: Auto-generated name with prefix
- **Features**: Standard features with simpler configuration
- **Purpose**: Development environment
- **Characteristics**:
  - Generated unique namespace name
  - Service account with token
  - Longer delete timeout (5m)
  - No backup policy
  - Simpler secret configuration

### 3. Staging Namespace (`staging-app`)
- **Type**: Explicit namespace name
- **Features**: Balanced configuration
- **Purpose**: Pre-production testing
- **Characteristics**:
  - Service account without auto-mounting
  - Token creation enabled
  - Beta release channel
  - SSO enabled
  - Network policy enforcement
  - Medium delete timeout (7m)

## Key Features Demonstrated

### Service Account Management
- **Production**: Full automation with token mounting
- **Development**: Full automation with token mounting
- **Staging**: Manual control (no auto-mounting)

### Image Pull Secrets
Multiple registries supported:
- Docker Registry
- AWS ECR
- Environment-specific credentials

### Labeling Strategy
- `environment`: Environment classification
- `team`: Team responsibility
- `tier`: Application tier
- `cost-center`: Cost allocation
- `compliance`: Compliance requirements
- `backup-policy`: Backup strategy
- `release-channel`: Release management

### Annotations
- `description`: Namespace purpose
- `owner`: Team contact
- `slack-channel`: Alert channel
- `runbook`: Operational documentation
- `backup.velero.io/backup`: Velero integration
- `prometheus.io/scrape`: Prometheus monitoring
- `policy.kyverno.io/enforce`: Policy enforcement
- `sso.enabled`: SSO integration status
- `network-policy.enabled`: Network policy status

## Outputs

The example provides comprehensive outputs for all three namespaces:

```bash
terraform output production_namespace
terraform output dev_namespace
terraform output staging_namespace
```

Each output includes:
- Namespace name
- Unique identifier (UID)
- Generation method (explicit or generated)
- Applied labels
- Applied annotations

## Prerequisites

Before applying this configuration:

### Create Required Secrets

```bash
# Production image pull secrets
kubectl create secret docker-registry docker-registry-prod \
  --docker-server=docker.io \
  --docker-username=<username> \
  --docker-password=<token> \
  -n production-app

kubectl create secret docker-registry ecr-prod-credential \
  --docker-server=<account>.dkr.ecr.<region>.amazonaws.com \
  --docker-username=AWS \
  --docker-password=<token> \
  -n production-app

kubectl create secret generic app-config-secret \
  --from-file=config.yaml \
  -n production-app

kubectl create secret tls tls-certs \
  --cert=path/to/cert.pem \
  --key=path/to/key.pem \
  -n production-app

# Development secrets
kubectl create secret docker-registry docker-registry-staging \
  --docker-server=docker.io \
  --docker-username=<username> \
  --docker-password=<token>

kubectl create secret docker-registry ecr-staging-credential \
  --docker-server=<account>.dkr.ecr.<region>.amazonaws.com \
  --docker-username=AWS \
  --docker-password=<token>

kubectl create secret generic staging-config \
  --from-file=config.yaml
```

## Requirements

- kubectl configured with access to a Kubernetes cluster
- Terraform >= 1.3
- Kubernetes Provider >= 3.0.0
- Pre-existing image pull secrets (if using the same names)

## Verification

After applying, verify the namespaces:

```bash
# List all namespaces
kubectl get namespaces -L environment,team,cost-center

# View detailed namespace information
kubectl describe namespace production-app
kubectl describe namespace staging-app
kubectl describe namespace $(kubectl get ns -l environment=development -o jsonpath='{.items[0].metadata.name}')

# Check service accounts
kubectl get serviceaccounts -n production-app
kubectl get secrets -n production-app

# View labels and annotations
kubectl get namespace production-app -o yaml
```

## Cleanup

```bash
terraform destroy

# Optional: Manually delete created secrets if not destroyed with namespaces
kubectl delete secret docker-registry-prod ecr-prod-credential -n production-app
kubectl delete secret app-config-secret tls-certs -n production-app
```

## Best Practices Illustrated

1. **Explicit Naming**: Use explicit names for production environments
2. **Generated Names**: Use generated names for ephemeral or temporary environments
3. **Comprehensive Labeling**: Apply labels for resource organization and automation
4. **Operational Metadata**: Use annotations for documentation and integration
5. **Environment-Specific Configuration**: Different settings for different environments
6. **Security**: Proper handling of service accounts and secrets
7. **Audit Trail**: Clear ownership and documentation
8. **Compliance**: Built-in support for compliance requirements

## Use Cases

- **Multi-environment deployments**: Production, staging, and development
- **Team segregation**: Isolated namespaces per team
- **Cost allocation**: Tracking resources by cost center
- **Compliance management**: PCI-DSS, HIPAA requirements
- **GitOps**: Infrastructure as Code best practices
- **CI/CD integration**: Automated namespace provisioning

## Advanced Customization

You can extend this example:

```hcl
# Add more namespaces for different teams
module "data_science_namespace" {
  source  = "tf-kubernetes-iaac/namespace/kubernetes"
  version = "2.0.0"
  name   = "data-science"
  # ... configuration
}

# Implement dynamic namespace creation
variable "namespaces" {
  type = map(object({
    name           = string
    environment    = string
    # ... other properties
  }))
}

module "dynamic_namespaces" {
  for_each = var.namespaces
  source  = "tf-kubernetes-iaac/namespace/kubernetes"
  version = "2.0.0"
  # ... configuration from each variable
}
```

## Troubleshooting

### Service account not using secrets
Check if `automount_service_account_token` is true and token is created.

### Image pull failures
Verify secrets exist in the namespace and are referenced correctly.

### Namespace stuck in terminating
Increase `delete_timeouts` value.

## Support

For issues or questions, refer to the main module [README.md](../../README.md).
