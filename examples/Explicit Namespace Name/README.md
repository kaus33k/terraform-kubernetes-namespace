### 🔹 Basic Usage (Explicit Namespace Name)

```hcl
module "namespace" {
  source  = "kaus33k/namespace/kubernetes"
  version = "0.0.2"

  name = "frontend"

  labels = {
    env = "prod"
  }
}
```