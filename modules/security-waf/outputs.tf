output "security_policy_id" {
  description = "The ID of the Cloud Armor security policy."
  value       = google_compute_security_policy.waf_policy.id
}

output "security_policy_name" {
  description = "The name of the Cloud Armor security policy."
  value       = google_compute_security_policy.waf_policy.name
}

output "security_policy_self_link" {
  description = "The URI of the Cloud Armor security policy."
  value       = google_compute_security_policy.waf_policy.self_link
}

output "external_ip_address" {
  description = "The reserved global external IP address for HTTPS load balancing."
  value       = try(google_compute_global_address.ingress_ip[0].address, null)
}

output "external_ip_name" {
  description = "The name of the reserved global external IP address."
  value       = try(google_compute_global_address.ingress_ip[0].name, null)
}

output "ssl_certificate_id" {
  description = "The ID of the Google-managed SSL certificate (if created)."
  value       = try(google_compute_managed_ssl_certificate.ssl_cert[0].id, null)
}

output "ssl_certificate_name" {
  description = "The name of the Google-managed SSL certificate (if created)."
  value       = try(google_compute_managed_ssl_certificate.ssl_cert[0].name, null)
}
