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
# Serverless VPC Access Connector (Connect Cloud Run to Private VPC)
# ------------------------------------------------------------------------------
resource "google_vpc_access_connector" "connector" {
  count         = var.enable_vpc_connector && var.vpc_connector_id == "" ? 1 : 0
  name          = "${substr(var.service_name, 0, 18)}-vpc-cx"
  project       = var.project_id
  region        = var.region
  network       = var.vpc_network_name
  ip_cidr_range = var.vpc_connector_cidr
  min_instances = 2
  max_instances = 3
  machine_type  = "e2-micro"
}

locals {
  effective_connector_id = var.enable_vpc_connector ? (
    var.vpc_connector_id != "" ? var.vpc_connector_id : google_vpc_access_connector.connector[0].id
  ) : null
}

# ------------------------------------------------------------------------------
# Dedicated Service Account for Cloud Run AI Service
# ------------------------------------------------------------------------------
resource "google_service_account" "cloudrun_sa" {
  account_id   = "${substr(var.service_name, 0, 24)}-sa"
  display_name = "Service Account for Cloud Run ${var.service_name}"
  project      = var.project_id
}

# ------------------------------------------------------------------------------
# IAM Bindings for AI Services & Observability
# ------------------------------------------------------------------------------
resource "google_project_iam_member" "aiplatform_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}

resource "google_project_iam_member" "bigquery_editor" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}

resource "google_project_iam_member" "bigquery_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}

resource "google_project_iam_member" "storage_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}

resource "google_project_iam_member" "log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}

# ------------------------------------------------------------------------------
# Cloud Run v2 Service
# ------------------------------------------------------------------------------
resource "google_cloud_run_v2_service" "service" {
  name     = var.service_name
  location = var.region
  project  = var.project_id
  ingress  = var.ingress_settings

  template {
    service_account = google_service_account.cloudrun_sa.email

    scaling {
      min_instance_count = var.min_instance_count
      max_instance_count = var.max_instance_count
    }

    dynamic "vpc_access" {
      for_each = local.effective_connector_id != null ? [1] : []
      content {
        connector = local.effective_connector_id
        egress    = "ALL_TRAFFIC"
      }
    }

    containers {
      image = var.container_image

      ports {
        container_port = var.container_port
      }

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }

      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }
}

# ------------------------------------------------------------------------------
# Optional Public Ingress (Invoker Role)
# ------------------------------------------------------------------------------
resource "google_cloud_run_v2_service_iam_member" "invoker" {
  count    = var.allow_unauthenticated ? 1 : 0
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
