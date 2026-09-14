output "service_id" {
  description = "The ID of the Cloud Run service."
  value       = google_cloud_run_v2_service.service.id
}

output "service_name" {
  description = "The name of the Cloud Run service."
  value       = google_cloud_run_v2_service.service.name
}

output "service_uri" {
  description = "The main URL endpoint of the Cloud Run service."
  value       = google_cloud_run_v2_service.service.uri
}

output "service_account_email" {
  description = "The email of the dedicated Cloud Run service account."
  value       = google_service_account.cloudrun_sa.email
}

output "vpc_connector_id" {
  description = "The ID of the VPC Access Connector used by the service."
  value       = local.effective_connector_id
}
