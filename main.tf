# ==============================================================================
# GCP AI Foundation Blueprint - Root Module
# Standards: Argolis, Google Cloud Well-Architected, Elevate & Spark
# ==============================================================================

# ------------------------------------------------------------------------------
# Collision-Resistant Random Suffix (Cloud Foundation Fabric / FAST pattern)
# ------------------------------------------------------------------------------
resource "random_string" "suffix" {
  count   = var.enable_random_suffix ? 1 : 0
  length  = var.random_suffix_length
  special = false
  upper   = false
  numeric = true
}

locals {
  name_prefix = var.enable_random_suffix ? "${var.resource_prefix}-${random_string.suffix[0].result}" : var.resource_prefix
}

# 1. Foundation Networking (VPC, Subnet, Secondary Ranges, Cloud NAT, PSA)
module "networking" {
  source = "./modules/networking"

  project_id                    = var.project_id
  region                        = var.region
  network_name                  = "${local.name_prefix}-vpc"
  subnet_name                   = "${local.name_prefix}-subnet"
  subnet_cidr                   = "10.10.0.0/20"
  pods_cidr_name                = "gke-pods"
  pods_cidr                     = "10.20.0.0/16"
  services_cidr_name            = "gke-services"
  services_cidr                 = "10.30.0.0/20"
  enable_flow_logs              = true
  enable_private_service_access = true
}

# 2. Security & Cloud Armor WAF
module "security_waf" {
  count  = var.enable_waf ? 1 : 0
  source = "./modules/security-waf"

  project_id                 = var.project_id
  policy_name                = "${local.name_prefix}-waf-policy"
  enable_adaptive_protection = true
  enable_owasp_rules         = true
  enable_rate_limiting       = true
  create_external_ip         = true
  ip_name                    = "${local.name_prefix}-global-ip"
  domain_name                = var.domain_name
  ssl_cert_name              = "${local.name_prefix}-ssl-cert"
  admin_email                = var.admin_email
}

# 3. Data & AI Foundation (Vertex AI APIs, BigQuery Lakehouse, GCS RAG Buckets)
module "data_ai" {
  source = "./modules/data-ai-foundation"

  project_id            = var.project_id
  region                = var.region
  dataset_id            = "${replace(local.name_prefix, "-", "_")}_lakehouse"
  dataset_friendly_name = "AI Lakehouse (${local.name_prefix})"
  rag_bucket_name       = "${var.project_id}-${local.name_prefix}-rag-docs"
  artifacts_bucket_name = "${var.project_id}-${local.name_prefix}-artifacts"
  labels                = var.labels
}

# 4. Compute: Private GKE Autopilot (Optional)
module "gke" {
  count  = var.enable_gke ? 1 : 0
  source = "./modules/compute-gke"

  project_id                    = var.project_id
  region                        = var.region
  cluster_name                  = "${local.name_prefix}-gke"
  network_id                    = module.networking.network_id
  subnet_id                     = module.networking.subnet_id
  pods_secondary_range_name     = module.networking.pods_secondary_range_name
  services_secondary_range_name = module.networking.services_secondary_range_name
  master_ipv4_cidr_block        = "172.16.254.0/28"
  deletion_protection           = false
}

# 5. Compute: Serverless Cloud Run (Optional)
module "cloudrun" {
  count  = var.enable_cloudrun ? 1 : 0
  source = "./modules/compute-cloudrun"

  project_id           = var.project_id
  region               = var.region
  service_name         = "${local.name_prefix}-service"
  enable_vpc_connector = true
  vpc_network_name     = module.networking.network_name
  vpc_connector_cidr   = "10.8.0.0/28"
  container_image      = "us-docker.pkg.dev/cloudrun/container/hello"
  min_instance_count   = 0
  max_instance_count   = 5
}

# 6. Bastion Host (Argolis Compliant: Zero Public IP, IAP Access)
module "bastion" {
  count  = var.enable_bastion ? 1 : 0
  source = "./modules/bastion"

  project_id       = var.project_id
  zone             = var.zone
  bastion_name     = "${local.name_prefix}-bastion"
  subnet_id        = module.networking.subnet_id
  machine_type     = "e2-small"
  enable_tinyproxy = true
}

# 7. Unified Observability (Cloud Logging to BigQuery & Monitoring Dashboard)
module "observability" {
  count  = var.enable_observability ? 1 : 0
  source = "./modules/observability"

  project_id             = var.project_id
  region                 = var.region
  sink_name              = "${local.name_prefix}-log-sink"
  create_log_dataset     = true
  log_dataset_name       = "${replace(local.name_prefix, "-", "_")}_logs"
  alert_email_address    = var.alert_email
  enable_dashboard       = true
  dashboard_display_name = "🤖 AI Foundation (${local.name_prefix}) - Cockpit Observabilité"
}
