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
  enable_private_service_access = false
}

module "waf" {
  source = "../../modules/security-waf"

  project_id           = var.project_id
  policy_name          = "${local.name_prefix}-waf"
  enable_owasp_rules   = true
  enable_rate_limiting = true
  create_external_ip   = true
}

module "data_ai" {
  source = "../../modules/data-ai-foundation"

  project_id            = var.project_id
  region                = var.region
  dataset_id            = "${replace(local.name_prefix, "-", "_")}_data"
  dataset_friendly_name = "Quick AI Dataset (${local.name_prefix})"
  random_suffix         = random_string.suffix.result
}

module "cloudrun" {
  source = "../../modules/compute-cloudrun"

  project_id            = var.project_id
  region                = var.region
  service_name          = "${local.name_prefix}-api"
  enable_vpc_connector  = true
  vpc_network_name      = module.networking.network_name
  vpc_connector_cidr    = "10.8.0.0/28"
  allow_unauthenticated = true
}
