variable "project_id" {
  description = "The GCP project ID to deploy data & AI resources into."
  type        = string
}

variable "region" {
  description = "The GCP region for BigQuery dataset and Cloud Storage buckets."
  type        = string
  default     = "europe-west1"
}

variable "dataset_id" {
  description = "The ID of the BigQuery Lakehouse dataset."
  type        = string
  default     = "ai_lakehouse"
}

variable "dataset_friendly_name" {
  description = "Friendly display name for the BigQuery dataset."
  type        = string
  default     = "AI Lakehouse & Vector Store"
}

variable "dataset_description" {
  description = "Description for the BigQuery dataset."
  type        = string
  default     = "Managed BigQuery dataset for AI grounding, vector search, embeddings, and analytics"
}

variable "default_table_expiration_ms" {
  description = "Default table expiration in milliseconds (null for permanent tables)."
  type        = number
  default     = null
}

variable "delete_contents_on_destroy" {
  description = "Whether to delete all tables in the dataset upon terraform destroy."
  type        = bool
  default     = false
}

variable "rag_bucket_name" {
  description = "Name for the RAG documents Cloud Storage bucket. Leave empty for auto-generated name."
  type        = string
  default     = ""
}

variable "artifacts_bucket_name" {
  description = "Name for the AI model artifacts & cache Cloud Storage bucket. Leave empty for auto-generated name."
  type        = string
  default     = ""
}

variable "random_suffix" {
  description = "Optional random suffix to append to default bucket names for collision prevention."
  type        = string
  default     = ""
}

variable "cors_allowed_origins" {
  description = "List of allowed origins for Cloud Storage CORS (e.g. web upload frontends)."
  type        = list(string)
  default     = ["*"]
}

variable "labels" {
  description = "Labels to apply to all resources."
  type        = map(string)
  default = {
    tier = "ai-foundation"
  }
}
