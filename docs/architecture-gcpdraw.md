# Schéma d'Architecture GCP Draw : GCP AI Foundation Blueprint

Ce schéma représente l'architecture globale de la solution **GCP AI Foundation Blueprint** formalisée en syntaxe **GCP Draw** (`go/gcpdraw`).

## 📋 Instructions d'utilisation
1. Rendez-vous sur l'outil officiel Google Cloud : **[GCP Draw (go/gcpdraw)](https://gcpdraw.corp.google.com)**.
2. Cliquez sur **Import / Code**.
3. Copiez-collez l'intégralité du bloc ci-dessous pour visualiser, éditer et exporter le schéma.

---

```text
meta {
  title "GCP AI Foundation Blueprint Architecture"
}

elements {
  card users as users {
    display_name "Enterprise Users"
  }

  gcp {
    card armor as waf {
      name "Cloud Armor WAF"
      description "OWASP Top 10 Active & DDoS Defense"
    }

    card load_balancer as lb {
      name "Global HTTP(S) Load Balancer"
      description "External Ingress & SSL Termination"
    }

    card iap as iap {
      name "Identity-Aware Proxy"
      description "Context-Aware Zero Trust Access"
    }

    group vpc_network {
      name "AI Foundation VPC Network"

      card run as cloud_run {
        name "Cloud Run v2"
        description "Direct VPC Egress & Serverless Microservices"
      }

      card gke as gke_autopilot {
        name "GKE Autopilot"
        description "Private Multi-Zone AI Workload Cluster"
      }

      card nat as cloud_nat {
        name "Cloud NAT & Router"
        description "Egress Internet Gateway without Public IPs"
      }
    }

    group data_ai {
      name "Data & AI Foundation"

      card storage as rag_storage {
        name "Cloud Storage"
        description "RAG Documents & Versioned Artifacts"
      }

      card bigquery as bq_lakehouse {
        name "BigQuery Lakehouse"
        description "Vector Store & Audit Log Analytics"
      }

      card vertex_ai as vertex_ai {
        name "Vertex AI Platform"
        description "Gemini 3.5/3.8 Flash & Embeddings"
      }
    }

    group ops {
      name "Observability & SRE"

      card monitoring as monitoring {
        name "Cloud Monitoring"
        description "Dashboards & SLO Budget Alerts"
      }

      card logging as logging {
        name "Cloud Logging"
        description "BigQuery Export with Schema Drift Shield"
      }

      card backup_and_dr as backup_dr {
        name "Backup & DR Service"
        description "Cross-Region WORM Vaults"
      }
    }
  }
}

paths {
  users -down-> waf
  waf --> lb
  lb --> iap
  iap -down-> cloud_run
  iap -down-> gke_autopilot

  cloud_run --> rag_storage : "Object Storage"
  cloud_run --> bq_lakehouse : "Queries"
  cloud_run --> vertex_ai : "Predictions"

  gke_autopilot --> bq_lakehouse : "Workload Identity"
  gke_autopilot --> vertex_ai : "Model Serving"

  gke_autopilot ..> cloud_nat : "Outbound"
  cloud_run ..> logging : "Audit Logs"
  gke_autopilot ..> monitoring : "Telemetry"
}
```
