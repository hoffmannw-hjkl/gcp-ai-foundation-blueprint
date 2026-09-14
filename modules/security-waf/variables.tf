variable "project_id" {
  description = "The GCP project ID to deploy security & WAF resources into."
  type        = string
}

variable "policy_name" {
  description = "Name of the Cloud Armor security policy."
  type        = string
  default     = "ai-foundation-waf-policy"
}

variable "enable_adaptive_protection" {
  description = "Enable Cloud Armor Adaptive Protection (Layer 7 ML DDoS Defense)."
  type        = bool
  default     = true
}

variable "enable_owasp_rules" {
  description = "Enable pre-configured OWASP Top 10 ModSecurity Core Rule Set rules in Cloud Armor."
  type        = bool
  default     = true
}

variable "enable_rate_limiting" {
  description = "Enable rate limiting rule against DDoS and brute-force attacks."
  type        = bool
  default     = true
}

variable "rate_limit_threshold_count" {
  description = "Maximum number of requests allowed per client IP within the interval."
  type        = number
  default     = 120
}

variable "rate_limit_interval_sec" {
  description = "Interval in seconds to evaluate request count (e.g. 60s)."
  type        = number
  default     = 60
}

variable "rate_limit_ban_duration_sec" {
  description = "Duration in seconds to ban/throttle client IP exceeding threshold."
  type        = number
  default     = 300
}

variable "preview_mode" {
  description = "Run WAF rules in preview mode (log matches without dropping traffic). Recommended during initial setup."
  type        = bool
  default     = false
}

variable "allowed_ip_ranges" {
  description = "Optional list of CIDR ranges explicitly allowed to access frontends."
  type        = list(string)
  default     = []
}

variable "denied_ip_ranges" {
  description = "Optional list of CIDR ranges explicitly denied."
  type        = list(string)
  default     = []
}

variable "create_external_ip" {
  description = "Allocate a reserved static global IPv4 address for external HTTPS Load Balancing."
  type        = bool
  default     = true
}

variable "ip_name" {
  description = "Name of the global reserved IP address."
  type        = string
  default     = "ai-foundation-global-ip"
}

variable "domain_name" {
  description = "Custom domain name (e.g. demo.altostrat.com or myapp.example.com) for Google-managed SSL Certificate. Leave empty to skip."
  type        = string
  default     = ""
}

variable "ssl_cert_name" {
  description = "Name of the Google-managed SSL certificate resource."
  type        = string
  default     = "ai-foundation-ssl-cert"
}

variable "admin_email" {
  description = "Email of the admin or group to grant roles/iap.httpsResourceAccessor for Zero Trust IAP access."
  type        = string
  default     = ""
}
