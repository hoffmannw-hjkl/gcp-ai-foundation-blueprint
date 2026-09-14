variable "billing_account_id" {
  description = "The Google Cloud Billing Account ID (format: 012345-678901-ABCDEF)."
  type        = string
}

variable "project_id" {
  description = "The GCP project ID to scope the budget alert."
  type        = string
}

variable "display_name" {
  description = "Display name for the billing budget."
  type        = string
  default     = "ai-foundation-monthly-budget"
}

variable "budget_amount" {
  description = "Monthly budget limit amount (e.g. 100 for a 100$ demo sandbox budget)."
  type        = number
  default     = 100
}

variable "currency_code" {
  description = "Currency code for the budget (e.g. USD, EUR)."
  type        = string
  default     = "USD"
}

variable "threshold_percent_list" {
  description = "List of current spend threshold percentages to trigger alerts (e.g. [0.5, 0.75, 0.9, 1.0])."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 1.0]
}

variable "enable_forecasted_threshold" {
  description = "Trigger an early warning alert if forecasted spend is projected to exceed 100% before month end."
  type        = bool
  default     = true
}

variable "alert_emails" {
  description = "List of email addresses to receive budget threshold alert notifications."
  type        = list(string)
  default     = []
}

variable "pubsub_topic_id" {
  description = "Optional Pub/Sub topic ID (projects/.../topics/...) for programmatic automated shutdown or Slack webhooks."
  type        = string
  default     = ""
}
