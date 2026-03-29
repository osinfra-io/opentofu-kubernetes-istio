# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  istio_test_virtual_services_merged = merge(var.istio_test_virtual_services, var.common_istio_test_virtual_services)
  virtual_services_merged            = merge(var.virtual_services, var.common_virtual_services)
}
