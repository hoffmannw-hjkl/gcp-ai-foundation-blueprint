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
  description = "Prefix applied to all created resource names to ensure uniqueness."
  type        = string
  default     = "ai-base"
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
