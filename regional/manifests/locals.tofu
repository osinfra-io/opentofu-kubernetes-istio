# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  # Region-specific routes take precedence over the common (all-region) routes on any shared key.
  # Each HTTPRoute is created in its backend's namespace (co-located with the Service it targets),
  # so the route attaches to its owning team's gateway listener via the osinfra.io/route-prefix
  # namespace label and no cross-namespace ReferenceGrant is required.
  routes_merged = merge(var.common_routes, var.routes)
}
