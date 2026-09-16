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
# Debian 12 Base Image
# ------------------------------------------------------------------------------
data "google_compute_image" "debian_12" {
  family  = "debian-12"
  project = "debian-cloud"
}

# ------------------------------------------------------------------------------
# Dedicated Service Account for Bastion VM
# ------------------------------------------------------------------------------
resource "google_service_account" "bastion_sa" {
  account_id   = "${trim(substr(var.bastion_name, 0, 24), "-")}-sa"
  display_name = "Service Account for IAP Bastion Host"
  project      = var.project_id
}


# ------------------------------------------------------------------------------
# Least-Privilege IAM Roles for Bastion
# ------------------------------------------------------------------------------
resource "google_project_iam_member" "logging_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.bastion_sa.email}"
}

resource "google_project_iam_member" "metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.bastion_sa.email}"
}

resource "google_project_iam_member" "container_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.bastion_sa.email}"
}

resource "google_project_iam_member" "aiplatform_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.bastion_sa.email}"
}

# ------------------------------------------------------------------------------
# Private Bastion VM (Argolis Compliant: Zero External IP, OS Login Enforced)
# ------------------------------------------------------------------------------
resource "google_compute_instance" "bastion" {
  name                      = var.bastion_name
  project                   = var.project_id
  zone                      = var.zone
  machine_type              = var.machine_type
  allow_stopping_for_update = true

  tags = concat(["bastion", "allow-iap"], var.extra_tags)

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_12.self_link
      size  = 30
      type  = "pd-standard"
    }
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  network_interface {
    subnetwork = var.subnet_id
    # IMPORTANT: No access_config block = NO external IP assigned (Argolis policy compliant)
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = <<-EOT
    #!/usr/bin/env bash
    set -euo pipefail

    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl gnupg jq tinyproxy git

    # Configure Tinyproxy if enabled
    if [ "${var.enable_tinyproxy}" = "true" ]; then
      sed -i 's/^Allow /#Allow /g' /etc/tinyproxy/tinyproxy.conf
      echo "Allow 10.0.0.0/8" >> /etc/tinyproxy/tinyproxy.conf
      echo "Allow 127.0.0.1" >> /etc/tinyproxy/tinyproxy.conf
      systemctl restart tinyproxy
      systemctl enable tinyproxy
    fi

    # Install Google Cloud SDK auth plugin & kubectl
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg --yes
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list
    apt-get update
    apt-get install -y google-cloud-cli-gke-gcloud-auth-plugin kubectl || true
  EOT

  service_account {
    email  = google_service_account.bastion_sa.email
    scopes = ["cloud-platform"]
  }
}
