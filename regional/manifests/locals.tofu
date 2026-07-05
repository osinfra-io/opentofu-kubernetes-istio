# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  istio_test_routes_merged = merge(var.istio_test_routes, var.common_istio_test_routes)
  routes_merged            = merge(var.routes, var.common_routes)

  # HTTPRoutes live in istio-ingress alongside the Gateway, while their backend Services live in
  # team/test namespaces. Gateway API requires a ReferenceGrant in each backend namespace to
  # authorize the cross-namespace backendRef. Collect the distinct backend namespaces.
  route_backend_namespaces = toset([
    for route in merge(local.istio_test_routes_merged, local.routes_merged) : route.backend_namespace
  ])
}
