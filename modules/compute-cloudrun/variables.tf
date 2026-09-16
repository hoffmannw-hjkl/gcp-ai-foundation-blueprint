variable "project_id" {
  description = "The GCP project ID to deploy Cloud Run into."
  type        = string
}

variable "region" {
  description = "The GCP region for the Cloud Run service and VPC connector."
  type        = string
  default     = "europe-west1"
}

variable "service_name" {
  description = "Name of the Cloud Run service."
  type        = string
  default     = "ai-service"
}

variable "container_image" {
  description = "Container image URL to deploy (e.g. Artifact Registry or public sample)."
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "container_port" {
  description = "Container listening port."
  type        = number
  default     = 8080
}

variable "cpu" {
  description = "Allocated CPU per instance (e.g. 1, 2, 4)."
  type        = string
  default     = "2"
}

variable "memory" {
  description = "Allocated memory per instance (e.g. 1Gi, 2Gi, 4Gi)."
  type        = string
  default     = "2Gi"
}

variable "min_instance_count" {
  description = "Minimum number of instances (0 for serverless cost savings)."
  type        = number
  default     = 0
}

variable "max_instance_count" {
  description = "Maximum number of instances for scaling."
  type        = number
  default     = 10
}

variable "ingress_settings" {
  description = "Ingress traffic settings (INGRESS_TRAFFIC_ALL, INGRESS_TRAFFIC_INTERNAL_ONLY, INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER)."
  type        = string
  default     = "INGRESS_TRAFFIC_ALL"
}

variable "allow_unauthenticated" {
  description = "Allow unauthenticated invocations (set false when behind IAP or requiring IAM tokens)."
  type        = bool
  default     = false
}

variable "env_vars" {
  description = "Environment variables map for the container."
  type        = map(string)
  default     = {}
}

variable "enable_direct_vpc_egress" {
  description = "Use Cloud Run v2 Direct VPC Egress instead of legacy Serverless VPC Access connector."
  type        = bool
  default     = true
}

variable "enable_vpc_connector" {
  description = "Legacy Serverless VPC Access connector (fallback if direct VPC egress is false)."
  type        = bool
  default     = false
}

variable "vpc_network_name" {
  description = "Name of the VPC network to connect to."
  type        = string
  default     = ""
}

variable "subnet_name" {
  description = "Subnet name for Direct VPC Egress."
  type        = string
  default     = ""
}

variable "vpc_egress" {
  description = "VPC Egress mode for Cloud Run: ALL_TRAFFIC or PRIVATE_RANGES_ONLY."
  type        = string
  default     = "ALL_TRAFFIC"
}

variable "vpc_connector_cidr" {
  description = "A dedicated /28 CIDR range for legacy Serverless VPC Access connector."
  type        = string
  default     = "10.8.0.0/28"
}

variable "vpc_connector_id" {
  description = "Optional existing VPC connector ID."
  type        = string
  default     = ""
}

variable "rag_bucket_name" {
  description = "Optional name of the RAG documents bucket to restrict IAM permissions."
  type        = string
  default     = ""
}

variable "artifacts_bucket_name" {
  description = "Optional name of the AI artifacts bucket to restrict IAM permissions."
  type        = string
  default     = ""
}

variable "dataset_id" {
  description = "Optional BigQuery dataset ID to restrict IAM dataEditor role."
  type        = string
  default     = ""
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection on the Cloud Run service."
  type        = bool
  default     = false
}

