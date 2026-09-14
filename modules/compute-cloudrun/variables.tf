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

variable "enable_vpc_connector" {
  description = "Connect Cloud Run to the private VPC via Serverless VPC Access."
  type        = bool
  default     = true
}

variable "vpc_network_name" {
  description = "Name of the VPC network to connect to (required if enable_vpc_connector is true and vpc_connector_id is empty)."
  type        = string
  default     = ""
}

variable "vpc_connector_cidr" {
  description = "A dedicated /28 CIDR range for the Serverless VPC Access connector (e.g. 10.8.0.0/28)."
  type        = string
  default     = "10.8.0.0/28"
}

variable "vpc_connector_id" {
  description = "Optional existing VPC connector ID. If empty and enable_vpc_connector is true, a new one is created."
  type        = string
  default     = ""
}
