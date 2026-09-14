output "vpc_network_id" {
  description = "VPC network ID."
  value       = module.networking.network_id
}

output "vpc_network_name" {
  description = "VPC network name."
  value       = module.networking.network_name
}

output "subnet_id" {
  description = "Primary subnet ID."
  value       = module.networking.subnet_id
}

output "waf_policy_id" {
  description = "Cloud Armor WAF Security Policy ID."
  value       = try(module.security_waf[0].security_policy_id, null)
}

output "external_ip" {
  description = "Reserved Global External IP for Load Balancing."
  value       = try(module.security_waf[0].external_ip_address, null)
}

output "lakehouse_dataset_id" {
  description = "BigQuery AI Lakehouse Dataset ID."
  value       = module.data_ai.dataset_id
}

output "rag_bucket_url" {
  description = "GCS Bucket URL for RAG documents."
  value       = module.data_ai.rag_bucket_url
}

output "artifacts_bucket_url" {
  description = "GCS Bucket URL for AI artifacts and model cache."
  value       = module.data_ai.artifacts_bucket_url
}

output "gke_cluster_name" {
  description = "GKE Autopilot cluster name (if enabled)."
  value       = try(module.gke[0].cluster_name, null)
}

output "gke_cluster_endpoint" {
  description = "GKE Autopilot cluster control plane endpoint (if enabled)."
  value       = try(module.gke[0].cluster_endpoint, null)
}

output "cloudrun_service_uri" {
  description = "Cloud Run service URI (if enabled)."
  value       = try(module.cloudrun[0].service_uri, null)
}

output "bastion_ssh_command" {
  description = "Command to connect to the private bastion host via IAP."
  value       = try(module.bastion[0].ssh_iap_command, null)
}

output "monitoring_dashboard_id" {
  description = "Cloud Monitoring dashboard ID."
  value       = try(module.observability[0].dashboard_id, null)
}
