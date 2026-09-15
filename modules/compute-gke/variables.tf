variable "project_id" {
  description = "The GCP project ID to deploy GKE into."
  type        = string
}

variable "region" {
  description = "The GCP region for the GKE cluster."
  type        = string
  default     = "europe-west1"
}

variable "cluster_name" {
  description = "Name of the GKE Autopilot cluster."
  type        = string
  default     = "ai-foundation-gke"
}

variable "network_id" {
  description = "The VPC network ID or self_link."
  type        = string
}

variable "subnet_id" {
  description = "The subnetwork ID or self_link for GKE nodes."
  type        = string
}

variable "pods_secondary_range_name" {
  description = "The name of the secondary IP range in the subnet for pods."
  type        = string
  default     = "gke-pods"
}

variable "services_secondary_range_name" {
  description = "The name of the secondary IP range in the subnet for services."
  type        = string
  default     = "gke-services"
}

variable "master_ipv4_cidr_block" {
  description = "The /28 IP CIDR block dedicated to the private GKE control plane."
  type        = string
  default     = "172.16.254.0/28"
}

variable "enable_private_endpoint" {
  description = "Whether the master's internal IP address is used as the cluster endpoint. If false, public endpoint is protected by master authorized networks."
  type        = bool
  default     = false
}

variable "master_authorized_cidr_blocks" {
  description = "List of CIDR blocks permitted to access the GKE control plane."
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = [
    {
      cidr_block   = "10.0.0.0/8"
      display_name = "internal-vpc-and-bastion"
    }
  ]
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace for the AI Workload Identity binding."
  type        = string
  default     = "default"
}

variable "kubernetes_service_account" {
  description = "Kubernetes service account name for the AI Workload Identity binding."
  type        = string
  default     = "ai-workload-sa"
}

variable "deletion_protection" {
  description = "Enable deletion protection on the cluster (recommended true for production, false for demos)."
  type        = bool
  default     = false
}

variable "enable_gke_backup" {
  description = "Enable GKE Backup agent and automated backup plan."
  type        = bool
  default     = false
}

variable "rag_bucket_name" {
  description = "Optional name of the RAG documents bucket to restrict IAM permissions."
  type        = string
  default     = ""
}

variable "dataset_id" {
  description = "Optional BigQuery dataset ID to restrict IAM dataEditor role."
  type        = string
  default     = ""
}
