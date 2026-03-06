# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  gateway_domains = keys(var.gateway_dns)

  gateway_helm_values = [
    for k, v in local.gateway_helm_values_map : {
      name  = k
      value = v
    }
  ]

  gateway_helm_values_map = {
    "autoscaling.minReplicas"                  = var.gateway_autoscale_min
    "labels.tags\\.datadoghq\\.com/env"        = module.helpers.environment
    "labels.tags\\.datadoghq\\.com/version"    = var.istio_version
    "podAnnotations.apm\\.datadoghq\\.com/env" = local.istio_gateway_datadog_apm_env
    "podAnnotations.proxy\\.istio\\.io/config" = <<EOF
    tracing:
      datadog:
        address: $(HOST_IP):8126
    proxyMetadata:
      DD_ENV: ${module.helpers.environment}
      DD_SERVICE: istio-gateway
      DD_VERSION: ${var.istio_version}
    EOF
    "resources.limits.cpu"                     = var.gateway_cpu_limits
    "resources.limits.memory"                  = var.gateway_memory_limits
    "resources.requests.cpu"                   = var.gateway_cpu_requests
    "resources.requests.memory"                = var.gateway_memory_requests
  }

  istio_gateway_datadog_apm_env = <<EOF
    {
    \"DD_ENV\":\"${module.helpers.environment}\"\,
    \"DD_SERVICE\":\"istio-gateway\"\,
    \"DD_VERSION\":\"${var.istio_version}\"
    }
  EOF

  istio_gateway_proxy_config = <<EOF
    {
    \"tracing\":{\"datadog\":{\"address\":\"$(HOST_IP):8126\"}}\,
    \"proxyMetadata\":{\"DD_ENV\":\"${module.helpers.environment}\"\,
    \"DD_SERVICE\":\"istio-gateway\"\,\"DD_VERSION\":\"${var.istio_version}\"\,
    \"ISTIO_META_DNS_AUTO_ALLOCATE\":\"true\"\,
    \"ISTIO_META_DNS_CAPTURE\":\"true\"\,
    \"meshId\":\"default\"
    }
  EOF

  istiod_helm_values = [
    for k, v in local.istiod_helm_values_map : {
      name  = k
      value = v
    }
  ]

  istiod_helm_values_map = {
    "autoscaleMin"                                    = var.pilot_autoscale_min
    "deploymentLabels.tags\\.datadoghq\\.com/env"     = module.helpers.environment
    "deploymentLabels.tags\\.datadoghq\\.com/version" = var.istio_version
    "global.hub"                                      = "${var.artifact_registry}/istio"
    "global.multiCluster.clusterName"                 = local.multi_cluster_name
    "global.proxy.resources.limits.cpu"               = var.proxy_cpu_limits
    "global.proxy.resources.limits.memory"            = var.proxy_memory_limits
    "global.proxy.resources.requests.cpu"             = var.proxy_cpu_requests
    "global.proxy.resources.requests.memory"          = var.proxy_memory_requests
    "podLabels.tags\\.datadoghq\\.com/env"            = module.helpers.environment
    "podLabels.tags\\.datadoghq\\.com/version"        = var.istio_version
    "replicaCount"                                    = var.pilot_replica_count
    "resources.limits.cpu"                            = var.pilot_cpu_limits
    "resources.limits.memory"                         = var.pilot_memory_limits
    "resources.requests.cpu"                          = var.pilot_cpu_requests
    "resources.requests.memory"                       = var.pilot_memory_requests
  }

  multi_cluster_name = module.helpers.zone != null ? "${var.cluster_prefix}-${module.helpers.region}-${module.helpers.zone}-${module.helpers.env}" : "${var.cluster_prefix}-${module.helpers.region}-${module.helpers.env}"
}
