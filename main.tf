# ==============================================================================
# GCP AI Foundation Blueprint - Root Module
# Standards: Argolis, Google Cloud Well-Architected, Elevate & Spark
# ==============================================================================

# 1. Foundation Networking (VPC, Subnet, Secondary Ranges, Cloud NAT, PSA)
module "networking" {
  source = "./modules/networking"

  project_id                    = var.project_id
  region                        = var.region
  network_name                  = "${var.resource_prefix}-vpc"
  subnet_name                   = "${var.resource_prefix}-subnet"
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
  policy_name                = "${var.resource_prefix}-waf-policy"
  enable_adaptive_protection = true
  enable_owasp_rules         = true
  enable_rate_limiting       = true
  create_external_ip         = true
  ip_name                    = "${var.resource_prefix}-global-ip"
  domain_name                = var.domain_name
  ssl_cert_name              = "${var.resource_prefix}-ssl-cert"
  admin_email                = var.admin_email
}

# 3. Data & AI Foundation (Vertex AI APIs, BigQuery Lakehouse, GCS RAG Buckets)
module "data_ai" {
  source = "./modules/data-ai-foundation"

  project_id            = var.project_id
  region                = var.region
  dataset_id            = "${replace(var.resource_prefix, "-", "_")}_lakehouse"
  dataset_friendly_name = "AI Lakehouse (${var.resource_prefix})"
  rag_bucket_name       = "${var.project_id}-${var.resource_prefix}-rag-docs"
  artifacts_bucket_name = "${var.project_id}-${var.resource_prefix}-artifacts"
  labels                = var.labels
}

# 4. Compute: Private GKE Autopilot (Optional)
module "gke" {
  count  = var.enable_gke ? 1 : 0
  source = "./modules/compute-gke"

  project_id                    = var.project_id
  region                        = var.region
  cluster_name                  = "${var.resource_prefix}-gke"
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
  service_name         = "${var.resource_prefix}-service"
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
  bastion_name     = "${var.resource_prefix}-bastion"
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
  sink_name              = "${var.resource_prefix}-log-sink"
  create_log_dataset     = true
  log_dataset_name       = "${replace(var.resource_prefix, "-", "_")}_logs"
  alert_email_address    = var.alert_email
  enable_dashboard       = true
  dashboard_display_name = "🤖 AI Foundation (${var.resource_prefix}) - Cockpit Observabilité"
}
