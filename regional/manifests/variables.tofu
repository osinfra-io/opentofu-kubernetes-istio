# Input Variables
# https://opentofu.org/docs/language/values/variables

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

variable "routes" {
  description = "The map of HTTPRoutes to create"
  type = map(object({
    backend_namespace = string
    backend_port      = optional(number, 8080)
    backend_service   = string
    host              = string
    path              = optional(string, "/")
  }))

  validation {
    condition     = alltrue([for route in var.routes : startswith(route.path, "/") && !strcontains(route.path, "//")])
    error_message = "Each route path must begin with '/' and must not contain consecutive slashes."
  }
}
