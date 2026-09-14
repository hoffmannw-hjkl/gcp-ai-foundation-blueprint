variable "project_id" {
  description = "The GCP project ID to deploy Backup and DR resources into."
  type        = string
}

variable "region" {
  description = "Primary GCP region for operational backups."
  type        = string
  default     = "europe-west1"
}

variable "dr_region" {
  description = "Secondary GCP region for geo-redundant DR vaults."
  type        = string
  default     = "europe-west4"
}

variable "vault_prefix" {
  description = "Prefix for backup vault naming."
  type        = string
  default     = "ai-demo"
}

variable "daily_retention_days" {
  description = "Enforced retention lock duration for daily operational vault (in days)."
  type        = number
  default     = 7
}

variable "weekly_retention_weeks" {
  description = "Enforced retention lock duration for weekly geo-redundant vault (in weeks)."
  type        = number
  default     = 4
}

variable "enable_geo_vault" {
  description = "Whether to create a cross-region geo-redundant backup vault in dr_region."
  type        = bool
  default     = true
}

variable "enable_gke_workload_backup" {
  description = "Whether to provision a GKE Backup Plan for Kubernetes application state, secrets and persistent volumes."
  type        = bool
  default     = true
}

variable "gke_cluster_id" {
  description = "The full resource ID of the GKE cluster to protect with Backup for GKE."
  type        = string
  default     = ""
}

variable "gke_backup_cron" {
  description = "Cron schedule for automated GKE application backups."
  type        = string
  default     = "0 2 * * *" # Daily at 02:00 AM UTC
}

variable "gke_backup_retention_days" {
  description = "Retention period for GKE application backups (in days)."
  type        = number
  default     = 30
}
