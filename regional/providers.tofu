terraform {
  required_providers {

    # Google Cloud Platform Provider
    # https://search.opentofu.org/provider/hashicorp/google/latest/docs

    google = {
      source = "hashicorp/google"
    }

    # Helm Provider
    # https://search.opentofu.org/provider/hashicorp/helm/latest/docs

    helm = {
      source = "hashicorp/helm"
    }

    # Kubernetes Provider
    # https://search.opentofu.org/provider/hashicorp/kubernetes/latest/docs

    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}
