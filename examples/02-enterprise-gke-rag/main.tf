terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }
}

provider "google" {
  project               = var.project_id
  region                = var.region
  user_project_override = true
  billing_project       = var.project_id
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
  numeric = true
}

locals {
  name_prefix = "${var.resource_prefix}-${random_string.suffix.result}"
}

module "networking" {
  source = "../../modules/networking"

  project_id                    = var.project_id
  region                        = var.region
  network_name                  = "${local.name_prefix}-vpc"
  subnet_name                   = "${local.name_prefix}-subnet"
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
  policy_name                = "${local.name_prefix}-waf"
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
  dataset_id            = "${replace(local.name_prefix, "-", "_")}_lakehouse"
  dataset_friendly_name = "Enterprise RAG Lakehouse (${local.name_prefix})"
  random_suffix         = random_string.suffix.result
}

module "gke" {
  source = "../../modules/compute-gke"

  project_id                    = var.project_id
  region                        = var.region
  cluster_name                  = "${local.name_prefix}-cluster"
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
  bastion_name = "${local.name_prefix}-bastion"
  subnet_id    = module.networking.subnet_id
}

module "observability" {
  source = "../../modules/observability"

  project_id         = var.project_id
  region             = var.region
  sink_name          = "${local.name_prefix}-sink"
  create_log_dataset = true
  log_dataset_name   = "${replace(local.name_prefix, "-", "_")}_logs"
  enable_dashboard   = true
}
