### 🔹 Generated Namespace Name

```
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
