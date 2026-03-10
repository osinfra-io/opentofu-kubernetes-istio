# Output Values
# https://opentofu.org/docs/language/values/outputs

output "gateway_mci_global_address" {
  description = "The IP address for the Istio Gateway multi-cluster ingress"
  value       = local.gateway_mci_global_address
}

output "gateway_mci_ssl_certificate_name" {
  description = "The name of the SSL certificate for the Istio Gateway multi-cluster ingress"
  value       = local.gateway_mci_ssl_certificate_name
}
