terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}

# ------------------------------------------------------------------------------
# Monitoring Notification Channels for Budget Alerts
# ------------------------------------------------------------------------------
resource "google_monitoring_notification_channel" "budget_email" {
  for_each     = toset(var.alert_emails)
  project      = var.project_id
  display_name = "FinOps Budget Alert - ${each.value}"
  type         = "email"
  labels = {
    email_address = each.value
  }
}

# ------------------------------------------------------------------------------
# Cloud Billing Budget Resource
# ------------------------------------------------------------------------------
resource "google_billing_budget" "budget" {
  billing_account = var.billing_account_id
  display_name    = var.display_name

  budget_filter {
    projects               = ["projects/${var.project_id}"]
    credit_types_treatment = "INCLUDE_ALL_CREDITS"
  }

  amount {
    specified_amount {
      currency_code = var.currency_code
      units         = tostring(var.budget_amount)
    }
  }

  # Current spend thresholds (50%, 75%, 90%, 100%)
  dynamic "threshold_rules" {
    for_each = var.threshold_percent_list
    content {
      threshold_percent = threshold_rules.value
      spend_basis       = "CURRENT_SPEND"
    }
  }

  # Forecasted spend threshold (early projection alert)
  dynamic "threshold_rules" {
    for_each = var.enable_forecasted_threshold ? [1] : []
    content {
      threshold_percent = 1.0
      spend_basis       = "FORECASTED_SPEND"
    }
  }

  all_updates_rule {
    monitoring_notification_channels = [for ch in google_monitoring_notification_channel.budget_email : ch.id]
    pubsub_topic                     = var.pubsub_topic_id != "" ? var.pubsub_topic_id : null
  }
}
