output "cluster_name" {
  description = "GKE Cluster name."
  value       = module.gke.cluster_name
}

output "cluster_endpoint" {
  description = "GKE Cluster endpoint."
  value       = module.gke.cluster_endpoint
}

output "bastion_ssh_command" {
  description = "Command to SSH into bastion host via IAP."
  value       = module.bastion.ssh_iap_command
}

output "external_ip" {
  description = "Reserved external IP for Ingress."
  value       = module.waf.external_ip_address
}

output "lakehouse_dataset" {
  description = "BigQuery Lakehouse dataset ID."
  value       = module.data_ai.dataset_id
}

output "rag_bucket" {
  description = "RAG document bucket URL."
  value       = module.data_ai.rag_bucket_url
}
