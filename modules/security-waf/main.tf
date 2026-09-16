terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}

locals {
  upload_path_exclusion = length(var.excluded_upload_paths) > 0 ? "!(${join(" || ", [for p in var.excluded_upload_paths : "request.path.startsWith('${p}')"])}) && " : ""
}

# ------------------------------------------------------------------------------
# Cloud Armor Security Policy (WAF & DDoS Mitigation)
# ------------------------------------------------------------------------------
resource "google_compute_security_policy" "waf_policy" {
  name        = var.policy_name
  project     = var.project_id
  description = "Cloud Armor Enterprise WAF Policy: OWASP Top 10, Rate Limiting, Adaptive Defense"

  dynamic "adaptive_protection_config" {
    for_each = var.enable_adaptive_protection ? [1] : []
    content {
      layer_7_ddos_defense_config {
        enable          = true
        rule_visibility = "STANDARD"
      }
    }
  }

  # ----------------------------------------------------------------------------
  # Denied IP Ranges (Explicit Blocklist)
  # ----------------------------------------------------------------------------
  dynamic "rule" {
    for_each = length(var.denied_ip_ranges) > 0 ? [1] : []
    content {
      action      = "deny(403)"
      priority    = "1000"
      description = "Explicit blocklist for malicious IP ranges"
      preview     = var.preview_mode

      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = var.denied_ip_ranges
        }
      }
    }
  }

  # ----------------------------------------------------------------------------
  # OWASP Top 10 Rules: Core Rule Set (CRS) v3.3
  #
  # Two cross-cutting adjustments are applied to every rule below:
  #
  #  1. Path exclusion for /api/documents/upload. Cloud Armor inspects request
  #     bodies, and the binary content of an uploaded PDF reliably trips the XSS
  #     and protocol-attack signatures. Without this exclusion every document
  #     upload is rejected with a 403 (body_denied_by_security_policy).
  #
  #  2. Preview mode is kept ONLY for the SQLi (2000) and XSS (2001) rules, which
  #     still produce false positives on IAP session cookies and redirect tokens.
  #     All other rules are actively enforced: leaving the whole rule set in
  #     preview would mean the WAF logs attacks without ever blocking them.
  # ----------------------------------------------------------------------------
  dynamic "rule" {
    for_each = var.enable_owasp_rules ? [
      { priority = "2000", expr = "${local.upload_path_exclusion}evaluatePreconfiguredExpr('sqli-v33-stable', ['owasp-crs-v030301-id942420-sqli', 'owasp-crs-v030301-id942421-sqli', 'owasp-crs-v030301-id942430-sqli', 'owasp-crs-v030301-id942431-sqli', 'owasp-crs-v030301-id942432-sqli'])", desc = "OWASP CRS: SQL Injection protection", preview = true },
      { priority = "2001", expr = "${local.upload_path_exclusion}evaluatePreconfiguredExpr('xss-v33-stable')", desc = "OWASP CRS: Cross-Site Scripting (XSS) protection", preview = true },
      { priority = "2002", expr = "${local.upload_path_exclusion}evaluatePreconfiguredExpr('lfi-v33-stable')", desc = "OWASP CRS: Local File Inclusion (LFI) protection", preview = var.preview_mode },
      { priority = "2003", expr = "${local.upload_path_exclusion}evaluatePreconfiguredExpr('rfi-v33-stable')", desc = "OWASP CRS: Remote File Inclusion (RFI) protection", preview = var.preview_mode },
      { priority = "2004", expr = "${local.upload_path_exclusion}evaluatePreconfiguredExpr('rce-v33-stable')", desc = "OWASP CRS: Remote Code Execution (RCE) protection", preview = var.preview_mode },
      { priority = "2005", expr = "${local.upload_path_exclusion}evaluatePreconfiguredExpr('protocolattack-v33-stable')", desc = "OWASP CRS: Protocol Attack protection", preview = var.preview_mode },
      { priority = "2006", expr = "${local.upload_path_exclusion}evaluatePreconfiguredExpr('scannerdetection-v33-stable')", desc = "OWASP CRS: Security Scanner Detection", preview = var.preview_mode },
      { priority = "2007", expr = "${local.upload_path_exclusion}evaluatePreconfiguredExpr('sessionfixation-v33-stable')", desc = "OWASP CRS: Session Fixation protection", preview = var.preview_mode }
    ] : []

    content {
      action      = "deny(403)"
      priority    = rule.value.priority
      description = rule.value.desc
      preview     = rule.value.preview

      match {
        expr {
          expression = rule.value.expr
        }
      }
    }
  }

  # ----------------------------------------------------------------------------
  # Rate Limiting Rule: Anti-DDoS & Anti-Bruteforce
  # ----------------------------------------------------------------------------
  dynamic "rule" {
    for_each = var.enable_rate_limiting ? [1] : []
    content {
      action      = "rate_based_ban"
      priority    = "3000"
      description = "Rate limiting: block IPs exceeding request threshold"
      preview     = var.preview_mode

      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = ["*"]
        }
      }

      rate_limit_options {
        conform_action = "allow"
        exceed_action  = "deny(429)"
        enforce_on_key = "IP"

        rate_limit_threshold {
          count        = var.rate_limit_threshold_count
          interval_sec = var.rate_limit_interval_sec
        }

        ban_threshold {
          count        = var.rate_limit_threshold_count * 2
          interval_sec = var.rate_limit_interval_sec
        }
        ban_duration_sec = var.rate_limit_ban_duration_sec
      }
    }
  }

  # ----------------------------------------------------------------------------
  # Default Rule: Allow legitimate traffic
  # ----------------------------------------------------------------------------
  rule {
    action      = "allow"
    priority    = "2147483647"
    description = "Default allow rule for all traffic passing WAF filters"

    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
  }
}

# ------------------------------------------------------------------------------
# Reserved Global External IP (for HTTPS External Load Balancer)
# ------------------------------------------------------------------------------
resource "google_compute_global_address" "ingress_ip" {
  count       = var.create_external_ip ? 1 : 0
  name        = var.ip_name
  project     = var.project_id
  description = "Reserved global external IPv4 address for AI services ingress"
}

# ------------------------------------------------------------------------------
# Google-managed SSL Certificate (Optional: if domain_name is provided)
# ------------------------------------------------------------------------------
resource "google_compute_managed_ssl_certificate" "ssl_cert" {
  count   = var.domain_name != "" ? 1 : 0
  name    = var.ssl_cert_name
  project = var.project_id

  managed {
    domains = [var.domain_name]
  }
}

# ------------------------------------------------------------------------------
# IAM Binding for Zero Trust IAP Web App Access (Optional)
# ------------------------------------------------------------------------------
resource "google_iap_web_iam_member" "iap_accessor" {
  count   = var.admin_email != "" ? 1 : 0
  project = var.project_id
  role    = "roles/iap.httpsResourceAccessor"
  member  = "user:${var.admin_email}"
}

