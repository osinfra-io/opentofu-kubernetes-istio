# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  # Region-specific routes take precedence over the common (all-region) routes on any shared key.
  istio_test_routes_merged = merge(var.common_istio_test_routes, var.istio_test_routes)
  routes_merged            = merge(var.common_routes, var.routes)

  # HTTPRoutes live in istio-ingress alongside the Gateway, while their backend Services live in
  # team/test namespaces. Gateway API requires a ReferenceGrant in each backend namespace to
  # authorize the cross-namespace backendRef. Collect the distinct backend namespaces from every
  # route's values (not a merged map, which could drop a namespace on a shared key).
  route_backend_namespaces = toset([
    for route in concat(
      values(local.istio_test_routes_merged),
      values(local.routes_merged),
    ) : route.backend_namespace
  ])
}
