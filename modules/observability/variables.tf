variable "project_id" {
  description = "The GCP project ID to deploy observability resources into."
  type        = string
}

variable "region" {
  description = "The GCP region for the BigQuery log dataset."
  type        = string
  default     = "europe-west1"
}

variable "enable_log_sink" {
  description = "Enable Cloud Logging sink exporting operational logs to BigQuery."
  type        = bool
  default     = true
}

variable "sink_name" {
  description = "Name of the Cloud Logging project sink."
  type        = string
  default     = "ai-foundation-log-sink"
}

variable "create_log_dataset" {
  description = "Whether to create a dedicated BigQuery dataset for central logs."
  type        = bool
  default     = true
}

variable "log_dataset_name" {
  description = "Name of the BigQuery dataset for logs."
  type        = string
  default     = "ai_foundation_logs"
}

variable "existing_bigquery_dataset_id" {
  description = "Existing BigQuery dataset ID to sink logs to if create_log_dataset is false."
  type        = string
  default     = ""
}

variable "log_filter" {
  description = "Cloud Logging sink filter. Includes strict exclusion of incompatible system schemas (kube-system, gke-gmp-system, jsonPayload.address) to prevent BigQuery table_invalid_schema errors."
  type        = string
  default     = "severity >= DEFAULT AND NOT (jsonPayload.plugins.ipam.ranges:*) AND NOT (resource.type=\"k8s_container\" AND (resource.labels.namespace_name=\"kube-system\" OR resource.labels.namespace_name=\"gke-gmp-system\")) AND NOT (jsonPayload.address:*)"
}

variable "alert_email_address" {
  description = "Optional email address to receive Cloud Monitoring alerts."
  type        = string
  default     = ""
}

variable "enable_dashboard" {
  description = "Whether to provision the Cloud Monitoring dashboard for AI workloads."
  type        = bool
  default     = true
}

variable "dashboard_display_name" {
  description = "Display name for the unified Cloud Monitoring dashboard."
  type        = string
  default     = "🤖 AI Foundation - Cockpit Observabilité & FinOps"
}

variable "force_destroy" {
  description = "Whether to delete dataset contents on destroy (useful for demo teardown)."
  type        = bool
  default     = false
}

