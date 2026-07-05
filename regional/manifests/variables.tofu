# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "common_istio_test_routes" {
  description = "The map of HTTPRoutes to create for Istio testing, that are common among all regions"
  type = map(object({
    backend_namespace = string
    backend_port      = optional(number, 8080)
    backend_service   = string
    host              = string
  }))
}

variable "common_routes" {
  description = "The map of HTTPRoutes to create, that are common among all regions"
  type = map(object({
    backend_namespace = string
    backend_port      = optional(number, 8080)
    backend_service   = string
    host              = string
  }))
}

variable "failover_from_region" {
  description = "The region to fail over from"
  type        = string
  default     = ""
}

variable "failover_to_region" {
  description = "The region to fail over to"
  type        = string
  default     = ""
}

variable "istio_test_routes" {
  description = "The map of HTTPRoutes to create for Istio testing"
  type = map(object({
    backend_namespace = string
    backend_port      = optional(number, 8080)
    backend_service   = string
    host              = string
  }))
}

variable "routes" {
  description = "The map of HTTPRoutes to create, that are unique to a region"
  type = map(object({
    backend_namespace = string
    backend_port      = optional(number, 8080)
    backend_service   = string
    host              = string
  }))
}
