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
  enable_private_service_access = false
}

module "waf" {
  source = "../../modules/security-waf"

  project_id           = var.project_id
  policy_name          = "${var.resource_prefix}-waf"
  enable_owasp_rules   = true
  enable_rate_limiting = true
  create_external_ip   = true
}

module "data_ai" {
  source = "../../modules/data-ai-foundation"

  project_id            = var.project_id
  region                = var.region
  dataset_id            = "${replace(var.resource_prefix, "-", "_")}_data"
  dataset_friendly_name = "Quick AI Dataset"
}

module "cloudrun" {
  source = "../../modules/compute-cloudrun"

  project_id            = var.project_id
  region                = var.region
  service_name          = "${var.resource_prefix}-api"
  enable_vpc_connector  = true
  vpc_network_name      = module.networking.network_name
  vpc_connector_cidr    = "10.8.0.0/28"
  allow_unauthenticated = true
}
