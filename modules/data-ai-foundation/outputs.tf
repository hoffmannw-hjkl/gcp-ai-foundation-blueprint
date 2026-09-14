output "dataset_id" {
  description = "The ID of the BigQuery Lakehouse dataset."
  value       = google_bigquery_dataset.ai_dataset.dataset_id
}

output "dataset_name" {
  description = "The friendly name of the BigQuery Lakehouse dataset."
  value       = google_bigquery_dataset.ai_dataset.friendly_name
}

output "rag_bucket_name" {
  description = "Name of the Cloud Storage bucket for RAG documents."
  value       = google_storage_bucket.rag_documents.name
}

output "rag_bucket_url" {
  description = "gs:// URL of the Cloud Storage bucket for RAG documents."
  value       = google_storage_bucket.rag_documents.url
}

output "artifacts_bucket_name" {
  description = "Name of the Cloud Storage bucket for AI artifacts and model cache."
  value       = google_storage_bucket.ai_artifacts.name
}

output "artifacts_bucket_url" {
  description = "gs:// URL of the Cloud Storage bucket for AI artifacts and model cache."
  value       = google_storage_bucket.ai_artifacts.url
}
