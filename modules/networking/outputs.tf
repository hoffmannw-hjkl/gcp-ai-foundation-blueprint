output "network_id" {
  description = "The ID of the created VPC network."
  value       = google_compute_network.vpc.id
}

output "network_name" {
  description = "The name of the created VPC network."
  value       = google_compute_network.vpc.name
}

output "network_self_link" {
  description = "The URI of the created VPC network."
  value       = google_compute_network.vpc.self_link
}

output "subnet_id" {
  description = "The ID of the primary subnet."
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_name" {
  description = "The name of the primary subnet."
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_self_link" {
  description = "The URI of the primary subnet."
  value       = google_compute_subnetwork.subnet.self_link
}

output "subnet_cidr" {
  description = "The primary IPv4 CIDR range of the subnet."
  value       = google_compute_subnetwork.subnet.ip_cidr_range
}

output "pods_secondary_range_name" {
  description = "Name of the secondary range for GKE pods."
  value       = var.pods_cidr_name
}

output "services_secondary_range_name" {
  description = "Name of the secondary range for GKE services."
  value       = var.services_cidr_name
}

output "router_name" {
  description = "Name of the Cloud Router."
  value       = google_compute_router.router.name
}

output "nat_name" {
  description = "Name of the Cloud NAT gateway."
  value       = google_compute_router_nat.nat.name
}
