output "cloudrun_url" {
  description = "Public URL of the deployed Cloud Run service."
  value       = module.cloudrun.service_uri
}

output "waf_policy_id" {
  description = "Cloud Armor WAF policy ID."
  value       = module.waf.security_policy_id
}

output "bigquery_dataset" {
  description = "BigQuery dataset ID."
  value       = module.data_ai.dataset_id
}
