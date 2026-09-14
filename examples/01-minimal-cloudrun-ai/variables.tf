variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region."
  type        = string
  default     = "europe-west1"
}

variable "resource_prefix" {
  description = "Prefix for resources."
  type        = string
  default     = "fast-ai"
}
