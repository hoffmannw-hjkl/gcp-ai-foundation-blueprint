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
# BigQuery Dataset for Centralized Operational Logs
# ------------------------------------------------------------------------------
resource "google_bigquery_dataset" "logs" {
  count                       = var.enable_log_sink && var.create_log_dataset ? 1 : 0
  dataset_id                  = var.log_dataset_name
  friendly_name               = "AI Foundation Logs"
  description                 = "Centralized BigQuery sink dataset for application, container, and infrastructure logs"
  location                    = var.region
  project                     = var.project_id
  default_table_expiration_ms = 7776000000 # 90 days log retention
  delete_contents_on_destroy  = var.force_destroy

  labels = {
    tier = "observability"
  }
}

locals {
  effective_dataset_id = var.create_log_dataset ? try(google_bigquery_dataset.logs[0].dataset_id, "") : var.existing_bigquery_dataset_id
}

# ------------------------------------------------------------------------------
# Cloud Logging Sink to BigQuery (Hardened Schema Drift Protection)
# ------------------------------------------------------------------------------
resource "google_logging_project_sink" "bq_sink" {
  count       = var.enable_log_sink ? 1 : 0
  name        = var.sink_name
  project     = var.project_id
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${local.effective_dataset_id}"
  filter      = var.log_filter

  unique_writer_identity = true

  bigquery_options {
    use_partitioned_tables = true
  }
}

# Grant BigQuery Data Editor to the sink's service account strictly on the log dataset
resource "google_bigquery_dataset_iam_member" "sink_writer" {
  count      = var.enable_log_sink && local.effective_dataset_id != "" ? 1 : 0
  project    = var.project_id
  dataset_id = local.effective_dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.bq_sink[0].writer_identity
}


# ------------------------------------------------------------------------------
# Cloud Monitoring: Notification Channel & Alert Policy
# ------------------------------------------------------------------------------
resource "google_monitoring_notification_channel" "email" {
  count        = var.alert_email_address != "" ? 1 : 0
  project      = var.project_id
  display_name = "AI Foundation Alert Email"
  type         = "email"
  labels = {
    email_address = var.alert_email_address
  }
}

resource "google_monitoring_alert_policy" "high_error_rate" {
  count        = var.alert_email_address != "" ? 1 : 0
  project      = var.project_id
  display_name = "AI Foundation - High Error Rate Alert"
  combiner     = "OR"

  conditions {
    display_name = "HTTP 5xx error rate > 5% over 5m"
    condition_threshold {
      filter          = "metric.type=\"loadbalancing.googleapis.com/https/request_count\" resource.type=\"https_lb_rule\" metric.label.response_code_class=\"500\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 5
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email[0].id]
}

# ------------------------------------------------------------------------------
# Unified Cloud Monitoring Dashboard
# ------------------------------------------------------------------------------
resource "google_monitoring_dashboard" "ai_dashboard" {
  count   = var.enable_dashboard ? 1 : 0
  project = var.project_id
  dashboard_json = jsonencode({
    displayName = var.dashboard_display_name
    gridLayout = {
      columns = "2"
      widgets = [
        {
          title = "GKE / Pods - CPU Utilization (mcores)"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter      = "metric.type=\"kubernetes.io/container/cpu/core_usage_time\" resource.type=\"k8s_container\" project=\"${var.project_id}\""
                    aggregation = { alignmentPeriod = "60s", perSeriesAligner = "ALIGN_RATE" }
                  }
                }
                plotType       = "LINE"
                legendTemplate = "$${resource.label.pod_name}"
              }
            ]
            timeshiftDuration = "0s"
            yAxis             = { label = "CPU Cores", scale = "LINEAR" }
          }
        },
        {
          title = "GKE / Pods - Memory Usage (Bytes)"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter      = "metric.type=\"kubernetes.io/container/memory/used_bytes\" resource.type=\"k8s_container\" project=\"${var.project_id}\""
                    aggregation = { alignmentPeriod = "60s", perSeriesAligner = "ALIGN_MEAN" }
                  }
                }
                plotType       = "LINE"
                legendTemplate = "$${resource.label.pod_name}"
              }
            ]
            timeshiftDuration = "0s"
            yAxis             = { label = "Memory (Bytes)", scale = "LINEAR" }
          }
        },
        {
          title = "Ingress & WAF - Request Count (req/s by response class)"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter      = "metric.type=\"loadbalancing.googleapis.com/https/request_count\" resource.type=\"https_lb_rule\" project=\"${var.project_id}\""
                    aggregation = { alignmentPeriod = "60s", perSeriesAligner = "ALIGN_RATE" }
                  }
                }
                plotType       = "STACKED_BAR"
                legendTemplate = "HTTP $${metric.label.response_code_class}"
              }
            ]
            timeshiftDuration = "0s"
            yAxis             = { label = "Requests / sec", scale = "LINEAR" }
          }
        },
        {
          title = "Ingress - Backend Latencies P95 (ms)"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter      = "metric.type=\"loadbalancing.googleapis.com/https/backend_latencies\" resource.type=\"https_lb_rule\" project=\"${var.project_id}\""
                    aggregation = { alignmentPeriod = "60s", perSeriesAligner = "ALIGN_PERCENTILE_95" }
                  }
                }
                plotType       = "LINE"
                legendTemplate = "Latency P95 (ms)"
              }
            ]
            timeshiftDuration = "0s"
            yAxis             = { label = "Latency (ms)", scale = "LINEAR" }
          }
        },
        {
          title = "Cloud Storage RAG Documents - Total Bytes"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter      = "metric.type=\"storage.googleapis.com/storage/total_bytes\" resource.type=\"gcs_bucket\" project=\"${var.project_id}\""
                    aggregation = { alignmentPeriod = "300s", perSeriesAligner = "ALIGN_MEAN" }
                  }
                }
                plotType       = "LINE"
                legendTemplate = "$${resource.label.bucket_name}"
              }
            ]
            timeshiftDuration = "0s"
            yAxis             = { label = "Total Bytes", scale = "LINEAR" }
          }
        },
        {
          title = "Cloud Run - Invocations & Container CPU"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter      = "metric.type=\"run.googleapis.com/request_count\" resource.type=\"cloud_run_revision\" project=\"${var.project_id}\""
                    aggregation = { alignmentPeriod = "60s", perSeriesAligner = "ALIGN_RATE" }
                  }
                }
                plotType       = "LINE"
                legendTemplate = "Invocations $${resource.label.service_name}"
              }
            ]
            timeshiftDuration = "0s"
            yAxis             = { label = "Invocations / sec", scale = "LINEAR" }
          }
        }
      ]
    }
  })
}
