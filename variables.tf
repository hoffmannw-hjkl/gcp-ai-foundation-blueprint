variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string
}

variable "region" {
  description = "Primary GCP region for resources."
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "Primary GCP zone for single-zone compute resources."
  type        = string
  default     = "europe-west1-b"
}

variable "resource_prefix" {
  description = "Base prefix applied to all created resource names."
  type        = string
  default     = "ai-base"
}

variable "enable_random_suffix" {
  description = "Append a collision-resistant random alphanumeric suffix to all resource names and GCS buckets."
  type        = bool
  default     = true
}

variable "random_suffix_length" {
  description = "Length of the random suffix (e.g. 4 for 'a8f2')."
  type        = number
  default     = 4
}

variable "enable_gke" {
  description = "Provision private GKE Autopilot cluster."
  type        = bool
  default     = true
}

variable "enable_cloudrun" {
  description = "Provision baseline Cloud Run service with Serverless VPC access."
  type        = bool
  default     = false
}

variable "enable_bastion" {
  description = "Provision private IAP-only Bastion VM."
  type        = bool
  default     = true
}

variable "enable_waf" {
  description = "Provision Cloud Armor WAF policy (OWASP Top 10 + Rate Limiting)."
  type        = bool
  default     = true
}

variable "enable_observability" {
  description = "Provision Cloud Logging sink to BigQuery and Monitoring dashboard."
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Domain name for Google-managed SSL Certificate (e.g. demo.altostrat.com). Leave empty to skip."
  type        = string
  default     = ""
}

variable "admin_email" {
  description = "Administrator email for IAP access."
  type        = string
  default     = ""
}

variable "alert_email" {
  description = "Email to receive SRE alert notifications."
  type        = string
  default     = ""
}

variable "labels" {
  description = "Standard labels to attach to all resources."
  type        = map(string)
  default = {
    managed_by  = "terraform"
    environment = "demo"
    framework   = "elevate-spark"
  }
}

variable "billing_account" {
  description = "Google Cloud Billing Account ID (e.g. 012345-678901-ABCDEF). If provided, an automated monthly budget alert is provisioned."
  type        = string
  default     = ""
}

variable "budget_amount" {
  description = "Monthly budget limit for the project (e.g. 100 for $100 demo budget)."
  type        = number
  default     = 100
}

variable "budget_currency" {
  description = "Currency code for the budget alert."
  type        = string
  default     = "USD"
}
