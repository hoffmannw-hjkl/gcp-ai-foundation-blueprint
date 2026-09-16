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
  excluded_upload_paths      = var.excluded_upload_paths
  create_external_ip         = true
  ip_name                    = "${local.name_prefix}-global-ip"
  domain_name                = var.domain_name
  ssl_cert_name              = "${local.name_prefix}-ssl-cert"
  admin_email                = var.admin_email
}

# 3. Data & AI Foundation (Vertex AI APIs, BigQuery Lakehouse, GCS RAG Buckets)
module "data_ai" {
  source = "./modules/data-ai-foundation"

  project_id                 = var.project_id
  region                     = var.region
  dataset_id                 = "${replace(local.name_prefix, "-", "_")}_lakehouse"
  dataset_friendly_name      = "AI Lakehouse (${local.name_prefix})"
  delete_contents_on_destroy = var.force_destroy
  rag_bucket_name            = "${var.project_id}-${local.name_prefix}-rag-docs"
  artifacts_bucket_name      = "${var.project_id}-${local.name_prefix}-artifacts"
  force_destroy              = var.force_destroy
  kms_key_name               = var.kms_key_name
  labels                     = var.labels
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
  deletion_protection           = var.deletion_protection
  enable_gke_backup             = var.enable_backup_dr
  dataset_id                    = module.data_ai.dataset_id
  rag_bucket_name               = module.data_ai.rag_bucket_name
  artifacts_bucket_name         = module.data_ai.artifacts_bucket_name
}

# 5. Compute: Serverless Cloud Run (Optional)
module "cloudrun" {
  count  = var.enable_cloudrun ? 1 : 0
  source = "./modules/compute-cloudrun"

  project_id               = var.project_id
  region                   = var.region
  service_name             = "${local.name_prefix}-service"
  vpc_network_name         = module.networking.network_name
  subnet_name              = module.networking.subnet_name
  enable_direct_vpc_egress = true
  deletion_protection      = var.deletion_protection
  dataset_id               = module.data_ai.dataset_id
  rag_bucket_name          = module.data_ai.rag_bucket_name
  artifacts_bucket_name    = module.data_ai.artifacts_bucket_name
  container_image          = "us-docker.pkg.dev/cloudrun/container/hello"
  min_instance_count       = 0
  max_instance_count       = 5
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
  force_destroy          = var.force_destroy
  alert_email_address    = var.alert_email
  enable_dashboard       = true
  dashboard_display_name = "🤖 AI Foundation (${local.name_prefix}) - Cockpit Observabilité"
}


# 8. FinOps: Cloud Billing Budget Alert (Optional)
module "finops_budget" {
  count  = var.billing_account != "" ? 1 : 0
  source = "./modules/finops-budget"

  billing_account_id = var.billing_account
  project_id         = var.project_id
  display_name       = "${local.name_prefix}-monthly-budget"
  budget_amount      = var.budget_amount
  currency_code      = var.budget_currency
  alert_emails       = var.alert_email != "" ? [var.alert_email] : []
}

# 9. Backup & Disaster Recovery (Optional: WORM Vaults & GKE Workload State)
module "backup_dr" {
  count  = var.enable_backup_dr ? 1 : 0
  source = "./modules/backup-dr"

  project_id                 = var.project_id
  region                     = var.region
  dr_region                  = var.dr_region
  vault_prefix               = local.name_prefix
  daily_retention_days       = var.backup_daily_retention_days
  weekly_retention_weeks     = var.backup_weekly_retention_weeks
  enable_geo_vault           = var.enable_geo_dr_vault
  enable_gke_workload_backup = var.enable_gke
  gke_cluster_id             = var.enable_gke ? module.gke[0].cluster_id : ""
}

