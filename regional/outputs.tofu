# Output Values
# https://opentofu.org/docs/language/values/outputs

output "gateway_ip" {
  description = "The IP address of the Istio Gateway"
  value       = local.istio_gateway_address
}
