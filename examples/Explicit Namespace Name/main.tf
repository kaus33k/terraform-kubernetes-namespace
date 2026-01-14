module "namespace" {
  source  = "kaus33k/namespace/kubernetes"
  version = "1.0.0"

  name = "frontend"

  labels = {
    env = "prod"
  }
}
