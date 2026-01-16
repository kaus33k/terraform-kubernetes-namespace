module "namespace" {
  source  = "tf-kubernetes-iaac/namespace/kubernetes"
  version = "2.0.0"

  name = "frontend"

  labels = {
    env = "prod"
  }
}
