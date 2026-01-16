# Namespace with Labels and Annotations Example

This example demonstrates best practices for organizing and managing Kubernetes namespaces with comprehensive labeling and annotations for operational clarity.

## Usage

```bash
cd with-labels-and-annotations
terraform init
terraform plan
terraform apply
```

## What This Example Creates

1. A Kubernetes namespace named `observability`
2. Multiple descriptive labels for:
   - Environment classification
   - Team assignment
   - Cost tracking
   - Backup policies
   - Compliance requirements
3. Operational annotations for:
   - Description and documentation
   - Team ownership
   - Backup integration
   - Notification channels
   - Project metadata

## Key Features

- **Organized Labeling**: Uses labels for resource selection and organization
- **Operational Metadata**: Annotations provide operational context
- **Backup Integration**: Velero backup annotations for disaster recovery
- **Monitoring Integration**: Slack notification references
- **Compliance Tracking**: Compliance and audit trail annotations
- **Documentation Links**: References to documentation wikis

## Outputs

- `namespace_name`: The name of the created namespace
- `namespace_labels`: All labels applied to the namespace
- `namespace_annotations`: All annotations applied to the namespace

## Label and Annotation Best Practices

### Labels (for selection and organization)
- `environment`: Identifies the deployment environment
- `team`: Identifies the responsible team
- `cost-center`: For cost allocation and billing
- `managed-by`: Indicates Terraform management
- `backup-policy`: Defines backup requirements
- `compliance`: Indicates if namespace is compliance-managed

### Annotations (for operational context)
- `description`: Human-readable description
- `owner`: Contact for the namespace
- `backup.velero.io/backup`: Enables Velero backup
- `notification.slack`: Slack channel for alerts
- `documentation`: Links to relevant documentation
- `created-date`: Audit trail information

## Prerequisites

- kubectl configured with access to a Kubernetes cluster
- Terraform >= 1.3
- Kubernetes Provider >= 3.0.0

## Use Cases

- Production namespaces requiring audit trails
- Multi-tenant clusters needing clear responsibility assignment
- Environments requiring backup and disaster recovery
- Organizations using label selectors for automation
- Teams implementing GitOps and IaC practices

## Cleanup

```bash
terraform destroy
```
