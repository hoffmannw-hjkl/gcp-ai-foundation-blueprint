variable "project_id" {
  description = "The GCP project ID to deploy the bastion VM into."
  type        = string
}

variable "zone" {
  description = "The GCP zone for the bastion VM (e.g. europe-west1-b)."
  type        = string
  default     = "europe-west1-b"
}

variable "bastion_name" {
  description = "Name of the bastion instance."
  type        = string
  default     = "ai-foundation-bastion"
}

variable "subnet_id" {
  description = "The subnet ID or self_link to attach the bastion network interface."
  type        = string
}

variable "machine_type" {
  description = "Machine type for the bastion VM (e.g. e2-micro, e2-small)."
  type        = string
  default     = "e2-small"
}

variable "enable_tinyproxy" {
  description = "Whether to configure tinyproxy on port 8888 for private GKE / API forwarding via IAP."
  type        = bool
  default     = true
}

variable "extra_tags" {
  description = "Additional network tags for the bastion VM."
  type        = list(string)
  default     = []
}
