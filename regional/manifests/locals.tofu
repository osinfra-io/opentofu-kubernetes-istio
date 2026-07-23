# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  # Region-specific routes take precedence over the common (all-region) routes on any shared key.
  # Each HTTPRoute is created in its backend's namespace (co-located with the Service it targets),
  # so its backendRef stays in-namespace and no cross-namespace ReferenceGrant is required. Every
  # route attaches to the single shared gateway listener (allowedRoutes from: All).
  routes_merged = merge(var.common_routes, var.routes)
}
