terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "networking" {
  source = "../../modules/networking"

  project_id                    = var.project_id
  region                        = var.region
  network_name                  = "${var.resource_prefix}-vpc"
  subnet_name                   = "${var.resource_prefix}-subnet"
  subnet_cidr                   = "10.10.0.0/20"
  pods_cidr_name                = "gke-pods"
  pods_cidr                     = "10.20.0.0/16"
  services_cidr_name            = "gke-services"
  services_cidr                 = "10.30.0.0/20"
  enable_private_service_access = true
}

module "waf" {
  source = "../../modules/security-waf"

  project_id                 = var.project_id
  policy_name                = "${var.resource_prefix}-waf"
  enable_adaptive_protection = true
  enable_owasp_rules         = true
  enable_rate_limiting       = true
  create_external_ip         = true
  domain_name                = var.domain_name
  admin_email                = var.admin_email
}

module "data_ai" {
  source = "../../modules/data-ai-foundation"

  project_id            = var.project_id
  region                = var.region
  dataset_id            = "${replace(var.resource_prefix, "-", "_")}_lakehouse"
  dataset_friendly_name = "Enterprise RAG Lakehouse"
}

module "gke" {
  source = "../../modules/compute-gke"

  project_id                    = var.project_id
  region                        = var.region
  cluster_name                  = "${var.resource_prefix}-cluster"
  network_id                    = module.networking.network_id
  subnet_id                     = module.networking.subnet_id
  pods_secondary_range_name     = module.networking.pods_secondary_range_name
  services_secondary_range_name = module.networking.services_secondary_range_name
  deletion_protection           = false
}

module "bastion" {
  source = "../../modules/bastion"

  project_id   = var.project_id
  zone         = var.zone
  bastion_name = "${var.resource_prefix}-bastion"
  subnet_id    = module.networking.subnet_id
}

module "observability" {
  source = "../../modules/observability"

  project_id         = var.project_id
  region             = var.region
  sink_name          = "${var.resource_prefix}-sink"
  create_log_dataset = true
  log_dataset_name   = "${replace(var.resource_prefix, "-", "_")}_logs"
  enable_dashboard   = true
}
