variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be a valid GCP project ID (6-30 lowercase letters, digits, or hyphens)."
  }
}

variable "region" {
  description = "Primary GCP region for resources."
  type        = string
  default     = "europe-west1"

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "The region must be a valid GCP region identifier (e.g. europe-west1, us-central1)."
  }
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

  validation {
    condition     = var.random_suffix_length >= 2 && var.random_suffix_length <= 8
    error_message = "The random_suffix_length must be between 2 and 8 characters."
  }
}

variable "enable_gke" {
  description = "Provision private GKE Autopilot cluster."
  type        = bool
  default     = true
}

variable "enable_cloudrun" {
  description = "Provision baseline Cloud Run service with Direct VPC Egress."
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

variable "excluded_upload_paths" {
  description = "List of URL path prefixes excluded from Cloud Armor OWASP body inspection to prevent false positives on document/PDF uploads."
  type        = list(string)
  default     = ["/api/documents/upload"]
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

  validation {
    condition     = var.budget_amount > 0
    error_message = "The budget_amount must be strictly greater than 0."
  }
}

variable "budget_currency" {
  description = "Currency code for the budget alert."
  type        = string
  default     = "USD"
}

variable "enable_backup_dr" {
  description = "Whether to provision the Backup & DR module (WORM compliance vaults and GKE workload backups)."
  type        = bool
  default     = false
}

variable "dr_region" {
  description = "Secondary GCP region for geo-redundant DR vaults."
  type        = string
  default     = "europe-west4"
}

variable "backup_daily_retention_days" {
  description = "Retention duration for daily operational backup vault (in days)."
  type        = number
  default     = 7

  validation {
    condition     = var.backup_daily_retention_days >= 1
    error_message = "Daily backup retention must be at least 1 day."
  }
}

variable "backup_weekly_retention_weeks" {
  description = "Retention duration for weekly geo-redundant DR backup vault (in weeks)."
  type        = number
  default     = 4

  validation {
    condition     = var.backup_weekly_retention_weeks >= 1
    error_message = "Weekly backup retention must be at least 1 week."
  }
}

variable "enable_geo_dr_vault" {
  description = "Whether to provision a cross-region geo-redundant backup vault in dr_region."
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection on stateful compute and data resources (recommended false for demos/sandboxes, true for production)."
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Allow deleting Cloud Storage buckets and BigQuery datasets containing data during terraform destroy (recommended true for demos/sandboxes, false for production)."
  type        = bool
  default     = false
}

variable "kms_key_name" {
  description = "Optional Cloud KMS CryptoKey ID (CMEK) for customer-managed encryption on BigQuery datasets and Cloud Storage buckets."
  type        = string
  default     = ""
}


