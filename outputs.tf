output "vpc_network_id" {
  description = "VPC network ID."
  value       = module.networking.network_id
}

output "vpc_network_name" {
  description = "VPC network short name (for Cloud Run Direct VPC Egress)."
  value       = module.networking.network_name
}

output "subnet_id" {
  description = "Primary subnet ID."
  value       = module.networking.subnet_id
}

output "subnet_name" {
  description = "Primary subnet short name (for Cloud Run Direct VPC Egress)."
  value       = module.networking.subnet_name
}

output "waf_policy_id" {
  description = "Cloud Armor WAF Security Policy full URI."
  value       = try(module.security_waf[0].security_policy_id, null)
}

output "waf_policy_name" {
  description = "Cloud Armor WAF Security Policy short name (for GKE BackendConfig)."
  value       = try(module.security_waf[0].security_policy_name, null)
}

output "external_ip" {
  description = "Reserved Global External IPv4 address for HTTPS Load Balancing."
  value       = try(module.security_waf[0].external_ip_address, null)
}

output "external_ip_name" {
  description = "Reserved Global External IP resource name (for Kubernetes Ingress annotation)."
  value       = try(module.security_waf[0].external_ip_name, null)
}

output "ssl_certificate_name" {
  description = "Google-managed SSL certificate name (for Kubernetes Ingress annotation)."
  value       = try(module.security_waf[0].ssl_certificate_name, null)
}

output "lakehouse_dataset_id" {
  description = "BigQuery AI Lakehouse Dataset ID."
  value       = module.data_ai.dataset_id
}

output "rag_bucket_name" {
  description = "Name of the GCS Bucket for RAG documents."
  value       = module.data_ai.rag_bucket_name
}

output "rag_bucket_url" {
  description = "GCS Bucket URL for RAG documents."
  value       = module.data_ai.rag_bucket_url
}

output "artifacts_bucket_name" {
  description = "Name of the GCS Bucket for AI artifacts and model cache."
  value       = module.data_ai.artifacts_bucket_name
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

output "gke_app_service_account_email" {
  description = "Google Service Account email for GKE Workload Identity."
  value       = try(module.gke[0].workload_service_account_email, null)
}

output "workload_identity_pool" {
  description = "Workload Identity Pool for GKE IAM bindings."
  value       = "${var.project_id}.svc.id.goog"
}

output "gke_get_credentials_command" {
  description = "Ready-to-run gcloud command to fetch kubeconfig credentials for the private GKE cluster via internal IP."
  value       = var.enable_gke ? "gcloud container clusters get-credentials ${module.gke[0].cluster_name} --region ${var.region} --project ${var.project_id} --internal-ip" : null
}

output "cloudrun_service_name" {
  description = "Cloud Run service name (if enabled)."
  value       = try(module.cloudrun[0].service_name, null)
}

output "cloudrun_service_uri" {
  description = "Cloud Run service URI (if enabled)."
  value       = try(module.cloudrun[0].service_uri, null)
}

output "cloudrun_service_account_email" {
  description = "Dedicated Service Account email for Cloud Run AI service (if enabled)."
  value       = try(module.cloudrun[0].service_account_email, null)
}

output "bastion_ssh_command" {
  description = "Command to connect to the private bastion host via IAP."
  value       = try(module.bastion[0].ssh_iap_command, null)
}

output "monitoring_dashboard_id" {
  description = "Cloud Monitoring dashboard ID."
  value       = try(module.observability[0].dashboard_id, null)
}

output "budget_id" {
  description = "Billing budget resource ID (if enabled)."
  value       = try(module.finops_budget[0].budget_id, null)
}

output "backup_daily_vault_id" {
  description = "Backup and DR daily operational vault ID (if enabled)."
  value       = try(module.backup_dr[0].daily_vault_id, null)
}

output "backup_geo_dr_vault_id" {
  description = "Backup and DR geo-redundant DR vault ID (if enabled)."
  value       = try(module.backup_dr[0].geo_dr_vault_id, null)
}

output "gke_backup_plan_id" {
  description = "Backup for GKE application state plan ID (if enabled)."
  value       = try(module.backup_dr[0].gke_backup_plan_id, null)
}

output "project_id" {
  description = "Google Cloud Project ID."
  value       = var.project_id
}

output "region" {
  description = "Primary Google Cloud Region."
  value       = var.region
}

output "bastion_name" {
  description = "Short name of the bastion host (if enabled)."
  value       = try(module.bastion[0].instance_name, null)
}

output "bastion_zone" {
  description = "Zone of the bastion host (if enabled)."
  value       = var.enable_bastion ? var.zone : null
}



