# Terraform Kubernetes Namespace Module

A reusable Terraform module for creating and managing **Kubernetes namespaces** with support for **explicit names** or **auto-generated names**, along with configurable labels, annotations, and optional service account management.

This module is designed to be **Terraform Registry–ready**, follows best practices, and includes strong input validation to prevent misconfiguration.

---

## ✨ Features

* Create Kubernetes namespaces declaratively
* Supports:

  * Explicit namespace names
  * Auto-generated namespace names using `generate_name`
* Optional custom default service account creation
* Support for image pull secrets and mountable secrets
* Service account token generation (required for Kubernetes >=1.24)
* Configurable delete timeouts
* Strong variable validation for safe usage
* Custom labels and annotations
* Clean outputs for downstream modules
* Compatible with CI/CD pipelines

---

## 📦 Requirements

| Name                | Version  |
| ------------------- | -------- |
| Terraform           | >= 1.3   |
| Kubernetes Provider | >= 3.0.0 |

---

## ⚙️ versions.tf

This module expects the following Terraform and provider versions:

```hcl
terraform {
  required_version = ">= 1.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.0.0"
    }
  }
}
```

---

## 🚀 Usage

### 🔹 Basic Usage (Explicit Namespace Name)

```hcl
module "namespace" {
  source  = "tf-kubernetes-iaac/namespace/kubernetes"
  version = "2.0.0"

  name = "frontend"

  labels = {
    env = "prod"
  }
}
```

---

### 🔹 Generated Namespace Name

```hcl
module "namespace" {
  source  = "tf-kubernetes-iaac/namespace/kubernetes"
  version = "2.0.0"

  generate_name = true
  name_prefix   = "dev"

  labels = {
    env = "dev"
  }
}
```

This will generate a namespace similar to:

```
dev-abc123
```

---

## 🔐 Input Variables

| Name                                    | Type          | Default | Description                                                            |
| --------------------------------------- | ------------- | ------- | ---------------------------------------------------------------------- |
| `name`                                  | `string`      | `""`    | Explicit name of the namespace. Leave empty if `generate_name = true`. |
| `generate_name`                         | `bool`        | `false` | Generate a namespace name when `name` is not provided.                 |
| `name_prefix`                           | `string`      | `""`    | Prefix used when generating the namespace name.                        |
| `labels`                                | `map(string)` | `{}`    | Labels to apply to the namespace.                                      |
| `annotations`                           | `map(string)` | `{}`    | Annotations to apply to the namespace.                                 |
| `delete_timeouts`                       | `string`      | `"5m"`  | Define the delete timeouts for the namespace.                          |
| `create_custom_default_service_account` | `bool`        | `false` | Create custom default service account for the namespace.                |
| `automount_service_account_token`       | `bool`        | `false` | Automatically mount the service account token in pods.                  |
| `image_pull_secrets`                    | `list(string)`| `[]`    | List of image pull secrets for the service account.                    |
| `mountable_secrets`                     | `list(string)`| `[]`    | List of secrets that can be mounted by pods.                           |
| `create_token`                          | `bool`        | `false` | Create a service-account-token secret (required for K8s >=1.24).       |

---

## ✅ Validation Rules

The module enforces the following rules:

* You **must** either:

  * Provide `name`, **OR**
  * Set `generate_name = true`
* You **cannot** provide both
* `name_prefix` must be non-empty when `generate_name = true`

Invalid configurations will fail during `terraform plan` with clear error messages.

---

## 📤 Outputs

| Name                          | Description                            |
| ----------------------------- | -------------------------------------- |
| `namespace_name`              | Final name of the Kubernetes namespace |
| `namespace_uid`               | UID of the namespace                   |
| `namespace_labels`            | Labels applied to the namespace        |
| `namespace_annotations`       | Annotations applied to the namespace   |
| `namespace_generation_method` | `explicit` or `generated`              |

---

## 📎 Examples

See the [`examples`](./examples) directory for complete working examples:

* **explicit-name** – Create a namespace with a fixed name
* **generated-name** – Create a namespace using auto-generated naming
* **with-service-account** – Create a namespace with custom service account configuration
* **with-labels-and-annotations** – Create a namespace with comprehensive labeling and annotations
* **with-image-pull-secrets** – Create a namespace with image pull secrets
* **complete-configuration** – Complete example with all features enabled

Each example includes its own `README.md` with usage instructions.

---

## 🧪 Compatibility

* Compatible with Terraform `plan`, `apply`, and `destroy`
* Safe for multi-environment deployments
* Works with GitOps and CI/CD workflows

---

## 🤝 Contributing

Contributions are welcome!

* Open an issue for bugs or enhancements
* Submit a pull request with clear context and examples

---

## 📄 License

This module is licensed under the **Apache-2.0 License**.

---

## 🙌 Author

Maintained by **Kaushik Raj Panta**

---

If you find this module useful, please ⭐ the repository and feel free to suggest improvements!
