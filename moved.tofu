# Moved Blocks
# https://opentofu.org/docs/language/moved

moved {
  from = google_dns_record_set.istio_gateway_mci
  to   = google_dns_record_set.istio_gateway_mcis
}
