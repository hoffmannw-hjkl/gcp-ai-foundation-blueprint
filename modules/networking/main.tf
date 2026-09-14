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
# VPC Network
# ------------------------------------------------------------------------------
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  description             = "Core VPC for AI Foundation workloads (Argolis / Well-Architected compliant)"
}

# ------------------------------------------------------------------------------
# Primary Subnet with Secondary Ranges (Argolis compliant: Private Google Access)
# ------------------------------------------------------------------------------
resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnet_name
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.vpc.id
  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = var.pods_cidr_name
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = var.services_cidr_name
    ip_cidr_range = var.services_cidr
  }

  dynamic "log_config" {
    for_each = var.enable_flow_logs ? [1] : []
    content {
      aggregation_interval = "INTERVAL_5_SEC"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }
}

# ------------------------------------------------------------------------------
# Cloud Router & Cloud NAT (Egress without public IPs on VMs/nodes)
# ------------------------------------------------------------------------------
resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat"
  project                            = var.project_id
  region                             = var.region
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# ------------------------------------------------------------------------------
# Private Service Access (PSA) for Managed Google Services
# ------------------------------------------------------------------------------
resource "google_compute_global_address" "psa_range" {
  count         = var.enable_private_service_access ? 1 : 0
  name          = "${var.network_name}-psa-range"
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.psa_prefix_length
  network       = google_compute_network.vpc.id
  description   = "Reserved internal IP block for Private Service Access (Cloud SQL, Vertex AI, etc.)"
}

resource "google_service_networking_connection" "psa_connection" {
  count                   = var.enable_private_service_access ? 1 : 0
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psa_range[0].name]
}

# ------------------------------------------------------------------------------
# Firewall Rules: Zero Trust & Least Privilege
# ------------------------------------------------------------------------------

# 1. Allow Identity-Aware Proxy (IAP) SSH / TCP Tunneling
resource "google_compute_firewall" "allow_iap" {
  name        = "${var.network_name}-allow-iap"
  project     = var.project_id
  network     = google_compute_network.vpc.id
  description = "Allow administrative access strictly via Google Identity-Aware Proxy (IAP)"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "8080", "8888"]
  }

  # Official Google Cloud IAP IP range
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-iap", "bastion"]
}

# 2. Allow Google Cloud Load Balancer Health Checks
resource "google_compute_firewall" "allow_health_checks" {
  name        = "${var.network_name}-allow-health-checks"
  project     = var.project_id
  network     = google_compute_network.vpc.id
  description = "Allow Google Cloud Load Balancers to perform health checks"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "8443", "10254"]
  }

  # Google Cloud LB health check probe ranges
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["gke-node", "load-balanced-backend"]
}

# 3. Allow internal communication within VPC subnet and secondary ranges
resource "google_compute_firewall" "allow_internal" {
  name        = "${var.network_name}-allow-internal"
  project     = var.project_id
  network     = google_compute_network.vpc.id
  description = "Allow internal traffic between primary and secondary ranges in the VPC"

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [
    var.subnet_cidr,
    var.pods_cidr,
    var.services_cidr
  ]
}
