variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "Primary GCP region."
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "Primary GCP zone for bastion."
  type        = string
  default     = "europe-west1-b"
}

variable "resource_prefix" {
  description = "Resource prefix."
  type        = string
  default     = "ent-ai"
}

variable "domain_name" {
  description = "Optional domain for SSL certificate."
  type        = string
  default     = ""
}

variable "admin_email" {
  description = "Admin email for IAP access."
  type        = string
  default     = ""
}
