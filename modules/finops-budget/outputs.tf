output "budget_id" {
  description = "The resource name/ID of the created billing budget."
  value       = google_billing_budget.budget.name
}

output "budget_display_name" {
  description = "The display name of the created billing budget."
  value       = google_billing_budget.budget.display_name
}
