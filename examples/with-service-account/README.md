# Service Account Configuration Example

This example demonstrates how to create a Kubernetes namespace with a custom default service account that includes:
- Automatic service account token generation
- Service account token mounting in pods
- Proper labeling and annotations

## Usage

```bash
cd with-service-account
terraform init
terraform plan
terraform apply
```

## What This Example Creates

1. A Kubernetes namespace named `backend-services`
2. A custom default service account for the namespace
3. A service account token secret (required for Kubernetes >=1.24)
4. Proper labels and annotations for organization

## Key Features

- **Default Service Account**: Creates a custom default service account with the namespace
- **Token Mounting**: Enables automatic token mounting in pods
- **Token Generation**: Creates the service account token secret explicitly
- **Labeling**: Applies labels for environment and management tracking
- **Annotations**: Adds annotations for team identification

## Outputs

- `namespace_name`: The name of the created namespace
- `service_account_namespace`: The namespace containing the service account

## Prerequisites

- kubectl configured with access to a Kubernetes cluster
- Terraform >= 1.3
- Kubernetes Provider >= 3.0.0

## Cleanup

```bash
terraform destroy
```

## Notes

This configuration is ideal for production namespaces where you need fine-grained control over the default service account and its token lifecycle. The token creation is especially important for Kubernetes clusters version 1.24+, where the default behavior changed.
