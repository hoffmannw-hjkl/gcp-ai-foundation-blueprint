output "log_sink_name" {
  description = "The name of the Cloud Logging sink."
  value       = try(google_logging_project_sink.bq_sink[0].name, null)
}

output "log_sink_writer_identity" {
  description = "The identity of the writer service account for the Cloud Logging sink."
  value       = try(google_logging_project_sink.bq_sink[0].writer_identity, null)
}

output "log_dataset_id" {
  description = "The BigQuery dataset ID where logs are written."
  value       = local.effective_dataset_id
}

output "dashboard_id" {
  description = "The resource ID of the provisioned Cloud Monitoring dashboard."
  value       = try(google_monitoring_dashboard.ai_dashboard[0].id, null)
}
