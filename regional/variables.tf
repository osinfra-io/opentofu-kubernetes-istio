# Input Variables
# https://www.terraform.io/language/values/variables

variable "artifact_registry" {
  description = "The registry to pull the images from"
  type        = string
  default     = "us-docker.pkg.dev/plt-lz-services-tf79-prod/plt-docker-virtual"
}

variable "chart_repository" {
  description = "The repository to pull the Istio Helm chart from"
  type        = string
  default     = "https://istio-release.storage.googleapis.com/charts"
}

variable "cluster_prefix" {
  description = "Prefix for your cluster name"
  type        = string
}

variable "enable_istio_gateway" {
  description = "Enable the Istio gateway, used for ingress traffic into the mesh"
  type        = bool
  default     = false
}

variable "environment" {
  description = "The environment must be one of `sandbox`, `non-production`, `production`"
  type        = string
  default     = "sandbox"

  validation {
    condition     = contains(["mock-environment", "sandbox", "non-production", "production"], var.environment)
    error_message = "The environment must be one of `mock-environment` for tests or `sandbox`, `non-production`, or `production`."
  }
}

variable "gateway_autoscale_min" {
  description = "The minimum number of gateway replicas to run"
  type        = number
  default     = 1
}

variable "gateway_cpu_limits" {
  description = "The CPU limit for the Istio gateway"
  type        = string
  default     = "100m"
}

variable "gateway_cpu_requests" {
  description = "The CPU request for the Istio gateway"
  type        = string
  default     = "25m"
}

variable "gateway_dns" {
  description = "Map of attributes for the Istio gateway domain names, it is also used to create the managed certificate resource"
  type = map(object({
    managed_zone = string
    project      = string
  }))
  default = {}
}

variable "gateway_mci_global_address" {
  description = "The IP address for the Istio Gateway multi-cluster ingress"
  type        = string
  default     = ""
}

variable "gateway_memory_limits" {
  description = "The memory limit for the Istio gateway"
  type        = string
  default     = "64Mi"
}

variable "gateway_memory_requests" {
  description = "The memory request for the Istio gateway"
  type        = string
  default     = "32Mi"
}

variable "istio_version" {
  description = "The version to install, this is used for the chart as well as the image tag"
  type        = string
  default     = "1.23.2"
}

variable "labels" {
  description = "A map of key/value pairs to assign to the resources being created"
  type        = map(string)
  default     = {}
}

variable "multi_cluster_service_clusters" {
  description = "List of clusters to be included in the MultiClusterService"
  type = list(object({
    link = string
  }))
  default = []
}

variable "node_location" {
  description = "The zone in which the cluster's nodes should be located. If not specified, the cluster's nodes are located across zones in the region"
  type        = string
  default     = null
}

variable "pilot_autoscale_min" {
  description = "The minimum number of Istio pilot replicas to run"
  type        = number
  default     = 1
}

variable "pilot_cpu_limits" {
  description = "The CPU limit for the Istio pilot"
  type        = string
  default     = "25m"
}

variable "pilot_cpu_requests" {
  description = "The CPU request for the Istio pilot"
  type        = string
  default     = "10m"
}

variable "pilot_memory_limits" {
  description = "The memory limit for the Istio pilot"
  type        = string
  default     = "64Mi"
}

variable "pilot_memory_requests" {
  description = "The memory request for the Istio pilot"
  type        = string
  default     = "32Mi"
}

variable "pilot_replica_count" {
  description = "The number of Istio pilot replicas to run"
  type        = number
  default     = 1
}

variable "project" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "proxy_cpu_limits" {
  description = "The CPU limit for the Istio proxy"
  type        = string
  default     = "25m"
}

variable "proxy_cpu_requests" {
  description = "The CPU request for the Istio proxy"
  type        = string
  default     = "10m"
}

variable "proxy_memory_limits" {
  description = "The memory limit for the Istio proxy"
  type        = string
  default     = "64Mi"
}

variable "proxy_memory_requests" {
  description = "The memory request for the Istio proxy"
  type        = string
  default     = "32Mi"
}

variable "region" {
  description = "The region in which the resource belongs"
  type        = string
}

variable "zone" {
  description = "The zone to deploy the resources to"
  type        = string
}
