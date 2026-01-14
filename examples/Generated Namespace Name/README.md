### 🔹 Generated Namespace Name

```
module "namespace" {
  source  = "kaus33k/namespace/kubernetes"
  version = "0.0.2"

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
