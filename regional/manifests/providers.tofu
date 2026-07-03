terraform {
  required_providers {

    # Kubernetes Provider
    # https://search.opentofu.org/provider/hashicorp/kubernetes/latest/docs

    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}
