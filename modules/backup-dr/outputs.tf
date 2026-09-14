output "daily_vault_id" {
  description = "Resource ID of the primary operational backup vault."
  value       = google_backup_dr_backup_vault.vault_daily.id
}

output "geo_dr_vault_id" {
  description = "Resource ID of the secondary geo-redundant DR backup vault."
  value       = try(google_backup_dr_backup_vault.vault_geo_dr[0].id, null)
}

output "gke_backup_plan_id" {
  description = "Resource ID of the GKE application state backup plan."
  value       = try(google_gke_backup_backup_plan.app_backup_plan[0].id, null)
}
