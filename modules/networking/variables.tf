variable "project_id" {
  description = "The GCP project ID to deploy networking resources into."
  type        = string
}

variable "region" {
  description = "The GCP region for the subnetwork and Cloud NAT."
  type        = string
  default     = "europe-west1"
}

variable "network_name" {
  description = "Name of the VPC network."
  type        = string
  default     = "ai-foundation-vpc"
}

variable "subnet_name" {
  description = "Name of the primary subnetwork."
  type        = string
  default     = "ai-foundation-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the primary subnetwork (nodes, VMs, connectors)."
  type        = string
  default     = "10.10.0.0/20"
}

variable "pods_cidr_name" {
  description = "Name of the secondary range for GKE pods."
  type        = string
  default     = "gke-pods"
}

variable "pods_cidr" {
  description = "Secondary IP range CIDR for GKE pods."
  type        = string
  default     = "10.20.0.0/16"
}

variable "services_cidr_name" {
  description = "Name of the secondary range for GKE services."
  type        = string
  default     = "gke-services"
}

variable "services_cidr" {
  description = "Secondary IP range CIDR for GKE services."
  type        = string
  default     = "10.30.0.0/20"
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs on the primary subnet for security auditing."
  type        = bool
  default     = true
}

variable "enable_private_service_access" {
  description = "Allocate an internal IP range and configure Private Service Access peering for Google managed services."
  type        = bool
  default     = true
}

variable "psa_prefix_length" {
  description = "Prefix length for Private Service Access (e.g. 16 for /16 range)."
  type        = number
  default     = 16
}
