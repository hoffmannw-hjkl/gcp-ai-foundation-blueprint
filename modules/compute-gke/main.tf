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
# Private GKE Autopilot Cluster (Argolis & Enterprise Compliant)
# ------------------------------------------------------------------------------
resource "google_container_cluster" "cluster" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.region

  enable_autopilot         = true
  enable_l4_ilb_subsetting = true
  deletion_protection      = var.deletion_protection

  network    = var.network_id
  subnetwork = var.subnet_id

  ip_allocation_policy {
    stack_type                    = "IPV4"
    services_secondary_range_name = var.services_secondary_range_name
    cluster_secondary_range_name  = var.pods_secondary_range_name
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_cidr_blocks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  addons_config {
    gke_backup_agent_config {
      enabled = var.enable_gke_backup
    }
  }

  timeouts {
    create = "60m"
    update = "30m"
    delete = "30m"
  }
}

# ------------------------------------------------------------------------------
# GKE Backup Plan (Optional)
# ------------------------------------------------------------------------------
resource "google_gke_backup_backup_plan" "daily_backup" {
  count    = var.enable_gke_backup ? 1 : 0
  name     = "${var.cluster_name}-daily-backup"
  cluster  = google_container_cluster.cluster.id
  location = var.region
  project  = var.project_id

  retention_policy {
    backup_retain_days      = 30
    backup_delete_lock_days = 0
  }

  backup_schedule {
    cron_schedule = "0 3 * * *"
  }

  backup_config {
    include_volume_data = true
    include_secrets     = true
    all_namespaces      = true
  }

  depends_on = [google_container_cluster.cluster]
}

# ------------------------------------------------------------------------------
# Dedicated Google Service Account for AI Workloads on GKE
# ------------------------------------------------------------------------------
resource "google_service_account" "workload_sa" {
  account_id   = "${var.cluster_name}-ai-sa"
  display_name = "Workload Identity SA for AI Applications on GKE"
  project      = var.project_id
}

# ------------------------------------------------------------------------------
# Least-Privilege IAM Bindings for AI Services
# ------------------------------------------------------------------------------

# 1. Vertex AI / Gemini API access
resource "google_project_iam_member" "aiplatform_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.workload_sa.email}"
}

# 2. BigQuery Data Editor & Job User (for vector store & analytics)
resource "google_bigquery_dataset_iam_member" "dataset_editor" {
  count      = var.dataset_id != "" ? 1 : 0
  project    = var.project_id
  dataset_id = var.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.workload_sa.email}"
}

resource "google_project_iam_member" "bigquery_editor" {
  count   = var.dataset_id == "" ? 1 : 0
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.workload_sa.email}"
}

resource "google_project_iam_member" "bigquery_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.workload_sa.email}"
}

# 3. Cloud Storage Access (RAG document embeddings & model artifacts)
resource "google_storage_bucket_iam_member" "rag_bucket_user" {
  count  = var.rag_bucket_name != "" ? 1 : 0
  bucket = var.rag_bucket_name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.workload_sa.email}"
}

resource "google_project_iam_member" "storage_object_viewer" {
  count   = var.rag_bucket_name == "" ? 1 : 0
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.workload_sa.email}"
}

# 4. Observability: Cloud Logging & Monitoring
resource "google_project_iam_member" "log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.workload_sa.email}"
}

resource "google_project_iam_member" "metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.workload_sa.email}"
}

# ------------------------------------------------------------------------------
# Workload Identity IAM Binding (GSA <-> KSA)
# ------------------------------------------------------------------------------
resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = google_service_account.workload_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.kubernetes_namespace}/${var.kubernetes_service_account}]"
  depends_on         = [google_container_cluster.cluster]
}
