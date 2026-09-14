output "cluster_id" {
  description = "The ID of the GKE cluster."
  value       = google_container_cluster.cluster.id
}

output "cluster_name" {
  description = "The name of the GKE cluster."
  value       = google_container_cluster.cluster.name
}

output "cluster_endpoint" {
  description = "The IP address of the GKE cluster master endpoint."
  value       = google_container_cluster.cluster.endpoint
}

output "cluster_ca_certificate" {
  description = "The public CA certificate used by the GKE cluster master."
  value       = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "workload_service_account_email" {
  description = "Email of the Google Service Account configured for GKE Workload Identity."
  value       = google_service_account.workload_sa.email
}

output "workload_service_account_name" {
  description = "Name of the Google Service Account configured for GKE Workload Identity."
  value       = google_service_account.workload_sa.name
}
