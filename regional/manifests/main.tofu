# Kubernetes Manifest Resource
# https://search.opentofu.org/provider/hashicorp/kubernetes/latest/docs/resources/manifest

resource "kubernetes_manifest" "istio_authorization_policy" {
  manifest = {
    apiVersion = "security.istio.io/v1"
    kind       = "AuthorizationPolicy"

    metadata = {
      name      = "deny-all"
      namespace = "istio-system"
    }

    # It's recommended to define authorization policies following the default-deny pattern to enhance your cluster's security posture.
    # The spec field of the policy has the empty value {}. That value means that no traffic is permitted, effectively denying all requests.

    spec = {}
  }
}

resource "kubernetes_manifest" "istio_cluster_services_destination_rule" {
  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind       = "DestinationRule"

    metadata = {
      annotations = {
        # IST0174: Wildcard host doesn't match specific services; this is intentional
        # for applying cluster-wide traffic policies.
        "galley.istio.io/analyze-suppress" = "IST0174"
      }
      name      = "cluster-services"
      namespace = "istio-system"
    }

    spec = {
      host = "*.svc.cluster.local"

      trafficPolicy = {
        connectionPool = {

          # ConnectionPoolSettings
          # https://istio.io/latest/docs/reference/config/networking/destination-rule/#ConnectionPoolSettings-HTTPSettings

          http = {
            maxRequestsPerConnection = 0 # This is the default value
          }
        }

        loadBalancer = {
          localityLbSetting = {
            enabled = true

            failover = [
              {
                from = var.failover_from_region
                to   = var.failover_to_region
              }
            ]
          }
          simple = "LEAST_REQUEST"
        }

        # OutlierDetection
        # https://istio.io/latest/docs/reference/config/networking/destination-rule/#OutlierDetection

        outlierDetection = {

          # These are the default values

          baseEjectionTime     = "30s"
          consecutive5xxErrors = 5
          interval             = "10s"
          maxEjectionPercent   = 10
        }
      }
    }
  }
}

resource "kubernetes_manifest" "istio_gateway_authorization_policy" {
  manifest = {
    apiVersion = "security.istio.io/v1"
    kind       = "AuthorizationPolicy"

    metadata = {
      name      = "allow-all-gateway"
      namespace = "istio-ingress"
    }

    spec = {
      action = "ALLOW"
      rules = [
        {
          to = [
            {
              operation = {
                methods = ["*"]
              }
            }
          ]
        }
      ]

      # Attach to the Gateway API Gateway (auto-provisioned data plane) via targetRefs rather
      # than a pod label selector.

      targetRefs = [
        {
          group = "gateway.networking.k8s.io"
          kind  = "Gateway"
          name  = "gateway"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "istio_http_routes" {
  for_each = local.routes_merged

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = each.key
      namespace = "istio-ingress"
    }

    spec = {
      hostnames = [
        each.value.host
      ]

      parentRefs = [
        {
          group = "gateway.networking.k8s.io"
          kind  = "Gateway"
          name  = "gateway"
        }
      ]

      rules = [
        {
          backendRefs = [
            {
              name      = each.value.backend_service
              namespace = each.value.backend_namespace
              port      = each.value.backend_port
            }
          ]
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "istio_kubernetes_default_destination_rule" {
  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind       = "DestinationRule"

    metadata = {
      annotations = {
        # IST0174: kubernetes.default.svc is the Kubernetes API server, not part of
        # the mesh. This rule disables mTLS to ensure API server access works.
        "galley.istio.io/analyze-suppress" = "IST0174"
      }
      name      = "kubernetes-default"
      namespace = "istio-system"
    }

    spec = {
      host = "kubernetes.default.svc"

      trafficPolicy = {
        tls = {
          mode = "DISABLE"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "istio_peer_authentication" {
  manifest = {
    apiVersion = "security.istio.io/v1beta1"
    kind       = "PeerAuthentication"

    metadata = {
      name      = "default"
      namespace = "istio-system"
    }

    spec = {
      mtls = {
        mode = "STRICT"
      }
    }
  }
}

resource "kubernetes_manifest" "istio_route_reference_grants" {
  for_each = local.route_backend_namespaces

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1beta1"
    kind       = "ReferenceGrant"

    metadata = {
      name      = "istio-ingress-routes"
      namespace = each.value
    }

    spec = {
      from = [
        {
          group     = "gateway.networking.k8s.io"
          kind      = "HTTPRoute"
          namespace = "istio-ingress"
        }
      ]

      to = [
        {
          group = ""
          kind  = "Service"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "istio_test_http_routes" {
  for_each = local.istio_test_routes_merged

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = each.key
      namespace = "istio-ingress"
    }

    spec = {
      hostnames = [
        each.value.host
      ]

      parentRefs = [
        {
          group = "gateway.networking.k8s.io"
          kind  = "Gateway"
          name  = "gateway"
        }
      ]

      rules = [
        {
          backendRefs = [
            {
              name      = each.value.backend_service
              namespace = each.value.backend_namespace
              port      = each.value.backend_port
            }
          ]

          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/istio-test"
              }
            }
          ]
        }
      ]
    }
  }
}
