# Image Pull Secrets Configuration Example

This example demonstrates how to create a Kubernetes namespace with image pull secrets for accessing private container registries.

## Usage

```bash
cd with-image-pull-secrets
terraform init
terraform plan
terraform apply
```

## What This Example Creates

1. A Kubernetes namespace named `private-registry`
2. A custom default service account with image pull secrets
3. Configuration for multiple private registry credentials:
   - Docker Registry
   - AWS ECR (Private)
   - GitHub Container Registry (GHCR)
4. Mountable secrets for pod volume mounts

## Key Features

- **Image Pull Secrets**: Allows pulling images from private registries
- **Multiple Registries**: Supports credentials for multiple registries
- **Mountable Secrets**: Secrets that pods can mount as volumes
- **Service Account Integration**: Automatic integration with default service account
- **Token Management**: Proper token generation and mounting

## Outputs

- `namespace_name`: The name of the created namespace
- `image_pull_secrets_configured`: List of configured image pull secrets

## Prerequisites

Before applying this configuration, you must create the image pull secrets in the cluster:

```bash
# Docker Registry Secret
kubectl create secret docker-registry docker-registry-credential \
  --docker-server=docker.io \
  --docker-username=<username> \
  --docker-password=<token> \
  --docker-email=<email> \
  -n private-registry

# AWS ECR Secret
kubectl create secret docker-registry private-ecr-credential \
  --docker-server=<aws-account>.dkr.ecr.<region>.amazonaws.com \
  --docker-username=AWS \
  --docker-password=<ecr-token> \
  -n private-registry

# GHCR Secret
kubectl create secret docker-registry ghcr-credential \
  --docker-server=ghcr.io \
  --docker-username=<github-username> \
  --docker-password=<github-token> \
  --docker-email=<email> \
  -n private-registry
```

## Usage Example

Once the namespace and secrets are configured, pods can be deployed using these image pull secrets:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
  namespace: private-registry
spec:
  imagePullSecrets:
    - name: docker-registry-credential
    - name: private-ecr-credential
  containers:
    - name: app
      image: <private-registry>/myapp:latest
```

Or using the service account directly (automatic):

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
  namespace: private-registry
spec:
  serviceAccountName: default
  containers:
    - name: app
      image: <private-registry>/myapp:latest
```

## Security Considerations

- Store registry credentials in a secure secret management system
- Use separate credentials for different environments (dev, staging, prod)
- Rotate credentials regularly
- Limit secret access with RBAC policies
- Consider using cloud provider native options (IAM roles for EKS, Workload Identity for GKE)

## Troubleshooting

If pods fail to pull images, verify:

```bash
# Check if the secret exists in the namespace
kubectl get secrets -n private-registry

# Check pod events for pull errors
kubectl describe pod <pod-name> -n private-registry

# Verify service account has the secret
kubectl get serviceaccount default -n private-registry -o yaml
```

## Requirements

- kubectl configured with access to a Kubernetes cluster
- Terraform >= 1.3
- Kubernetes Provider >= 3.0.0
- Pre-existing image pull secrets in the cluster

## Cleanup

```bash
terraform destroy

# Optionally remove the secrets (optional if destroying entire namespace)
kubectl delete secret docker-registry-credential -n private-registry
kubectl delete secret private-ecr-credential -n private-registry
kubectl delete secret ghcr-credential -n private-registry
```
