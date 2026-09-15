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
# API Enablement (Vertex AI & BigQuery)
# ------------------------------------------------------------------------------
resource "google_project_service" "aiplatform" {
  project                    = var.project_id
  service                    = "aiplatform.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "bigquery" {
  project                    = var.project_id
  service                    = "bigquery.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

# ------------------------------------------------------------------------------
# BigQuery Lakehouse & Vector Store Dataset
# ------------------------------------------------------------------------------
resource "google_bigquery_dataset" "ai_dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = var.dataset_friendly_name
  description                 = var.dataset_description
  location                    = var.region
  project                     = var.project_id
  default_table_expiration_ms = var.default_table_expiration_ms
  delete_contents_on_destroy  = var.delete_contents_on_destroy

  labels = var.labels

  depends_on = [google_project_service.bigquery]
}

# ------------------------------------------------------------------------------
# Cloud Storage: RAG Document Store
# ------------------------------------------------------------------------------
locals {
  suffix_part                = var.random_suffix != "" ? "-${var.random_suffix}" : ""
  effective_rag_bucket       = var.rag_bucket_name != "" ? var.rag_bucket_name : "${var.project_id}-rag-docs${local.suffix_part}"
  effective_artifacts_bucket = var.artifacts_bucket_name != "" ? var.artifacts_bucket_name : "${var.project_id}-ai-artifacts${local.suffix_part}"
}

resource "google_storage_bucket" "rag_documents" {
  name                        = local.effective_rag_bucket
  project                     = var.project_id
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  dynamic "cors" {
    for_each = length(var.cors_allowed_origins) > 0 ? [1] : []
    content {
      origin          = var.cors_allowed_origins
      method          = ["GET", "HEAD", "PUT", "POST"]
      response_header = ["*"]
      max_age_seconds = 3600
    }
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      num_newer_versions = 3
      with_state         = "ARCHIVED"
    }
  }

  labels = var.labels
}

# ------------------------------------------------------------------------------
# Cloud Storage: Model Artifacts & Evaluation Cache
# ------------------------------------------------------------------------------
resource "google_storage_bucket" "ai_artifacts" {
  name                        = local.effective_artifacts_bucket
  project                     = var.project_id
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition {
      age        = 30
      with_state = "LIVE"
    }
  }

  lifecycle_rule {
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
    condition {
      age        = 60
      with_state = "LIVE"
    }
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age        = 180
      with_state = "LIVE"
    }
  }

  labels = var.labels
}
