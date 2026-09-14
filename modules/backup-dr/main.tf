terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.0.0"
    }
  }
}

# ------------------------------------------------------------------------------
# 1. Primary Operational Backup Vault (Local Region)
# WORM Compliance: Enforced Minimum Retention Lock
# ------------------------------------------------------------------------------
resource "google_backup_dr_backup_vault" "vault_daily" {
  provider                                   = google-beta
  project                                    = var.project_id
  location                                   = var.region
  backup_vault_id                            = "${var.vault_prefix}-vault-daily"
  description                                = "Daily Operational Backup Vault with immutable retention lock."
  backup_minimum_enforced_retention_duration = "${var.daily_retention_days * 86400}s"
  force_update                               = true
  allow_missing                              = true
}

# ------------------------------------------------------------------------------
# 2. Geo-Redundant Disaster Recovery Vault (Secondary Region)
# Anti-Ransomware & Regional Outage Resilience
# ------------------------------------------------------------------------------
resource "google_backup_dr_backup_vault" "vault_geo_dr" {
  count                                      = var.enable_geo_vault ? 1 : 0
  provider                                   = google-beta
  project                                    = var.project_id
  location                                   = var.dr_region
  backup_vault_id                            = "${var.vault_prefix}-vault-geo-dr"
  description                                = "Geo-Redundant DR Backup Vault located in ${var.dr_region}."
  backup_minimum_enforced_retention_duration = "${var.weekly_retention_weeks * 7 * 86400}s"
  force_update                               = true
  allow_missing                              = true
}

# ------------------------------------------------------------------------------
# 3. GKE Workload & Application State Backup Plan (Backup for GKE)
# Protège l'état applicatif : Deployments, ConfigMaps, Secrets et Volumes (PVCs)
# ------------------------------------------------------------------------------
resource "google_gke_backup_backup_plan" "app_backup_plan" {
  count    = var.enable_gke_workload_backup && var.gke_cluster_id != "" ? 1 : 0
  project  = var.project_id
  name     = "${var.vault_prefix}-gke-app-backup"
  cluster  = var.gke_cluster_id
  location = var.region

  retention_policy {
    backup_retain_days      = var.gke_backup_retention_days
    backup_delete_lock_days = 0
  }

  backup_schedule {
    cron_schedule = var.gke_backup_cron
  }

  backup_config {
    include_volume_data = true
    include_secrets     = true
    all_namespaces      = true
  }
}
