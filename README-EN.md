> 🇫🇷 **[Version Française](README.md)** | 🇬🇧 **[English Version](README-EN.md)**
>
> 🔗 **EMEA SPARK Ecosystem & Companion Applications:**
> This repository provides the **Enterprise Infrastructure Foundation (IaC Landing Zone)**. To explore companion applications running on top of this foundation:
> - **[RAG Comparison Demo (cloud-gtm/app-rag-comparison)](https://github.com/cloud-gtm/app-rag-comparison)**: Lexical Search vs Hybrid Grounded RAG (Embeddings 002 + BM25), SSE streaming, and Vertex AI Autorater GenAI evaluation.
> - **[CivicLens (cloud-gtm/civiclens)](https://github.com/cloud-gtm/civiclens)**: Public finance analytics platform (GKE Autopilot, Cloud SQL pgvector, multimodal Gemini).

# GCP AI Foundation Blueprint

[![Terraform Version](https://img.shields.io/badge/Terraform-1.5+-623CE4?style=flat&logo=terraform)](https://www.terraform.io/)
[![Google Cloud Provider](https://img.shields.io/badge/Google_Cloud_Provider-5.0+-4285F4?style=flat&logo=google-cloud)](https://registry.terraform.io/providers/hashicorp/google/latest)
[![Security Standard](https://img.shields.io/badge/Security-Argolis_%7C_Zero_Trust-green)](docs/ARCHITECTURE.md)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

Modular Terraform infrastructure foundation for deploying Artificial Intelligence applications and GenAI workloads on Google Cloud Platform.

This blueprint provides a production-grade reference architecture aligned with **Google Cloud Well-Architected Framework** guidelines and strict **Google Cloud Argolis** governance rules (zero public IPs on compute workloads, IAP tunnel administration, Google-managed encryption, and least-privilege IAM).

---

## Architecture Overview

Review the interactive architectural diagram in GCP Draw format in [docs/architecture-gcpdraw.md](docs/architecture-gcpdraw.md).

```mermaid
flowchart TD
    subgraph Internet_Edge ["1. Edge & Perimeter Security"]
        User(["Client / Demonstrator"]) --> LB["External HTTPS Load Balancer\n(Static Global IP + Managed SSL)"]
        LB --> WAF["Cloud Armor WAF Policy\n- OWASP Top 10 CRS\n- Rate Limiting (120 req/min)\n- Adaptive ML Defense"]
        LB --> IAP["Identity-Aware Proxy (IAP)\nZero Trust OAuth2"]
    end

    subgraph VPC ["2. Private VPC (Argolis-Ready, Zero Public IPs)"]
        IAP -->|Secure Ingress| GKE["Private GKE Autopilot Cluster\n- 100% Private Nodes\n- Workload Identity (GSA <-> KSA)"]
        IAP -->|Secure Ingress| CR["Cloud Run v2 (Serverless)\n+ Direct VPC Egress"]
        
        Admin(["Admin / SRE"]) -->|IAP Tunnel 35.235.240.0/20| Bastion["Private Bastion VM\n(OS Login, Debian 12, kubectl)"]
        Bastion -.->|Private Administration| GKE

        GKE --> NAT["Cloud Router + Cloud NAT"]
        CR --> NAT
        NAT -->|Secure Egress| EgressNet(["External APIs / GitHub / HuggingFace"])
    end

    subgraph Data_AI ["3. Data & AI Managed Foundation"]
        GKE & CR -->|Private Google Access / Workload Identity| VertexAI["Vertex AI / Gemini API\n(Gemini 3.5/3.8, text-embedding-002)"]
        GKE & CR -->|Private Service Access / Peering| BQ["BigQuery AI Lakehouse\n- Analytical Datasets\n- Vector Indexing & Embeddings"]
        GKE & CR --> GCS["Cloud Storage\n- gs://...-rag-docs (UBLA, Versioning)\n- gs://...-artifacts (Models, Cache)"]
    end

    subgraph SRE_Observability ["4. Observability & SRE Resilience"]
        GKE & CR & WAF --> Sink["Cloud Logging Sink\n(Strict anti table_invalid_schema filter)"]
        Sink --> BQLogs["BigQuery Logs Dataset\n(Partitioned tables, 90-day retention)"]
        GKE & CR & LB --> Dash["Cloud Monitoring Cockpit\n(P95 Latency, CPU/RAM, WAF Traffic)"]
    end
```

---

## Module Catalog

The blueprint consists of 9 decoupled, composable Terraform modules:

| Module | Directory | Description & Key Resources |
| :--- | :--- | :--- |
| **Networking** | `modules/networking` | Custom VPC, primary subnet (`10.10.0.0/20`), secondary ranges for Pods (`10.20.0.0/16`) and Services (`10.30.0.0/20`), Cloud Router, Cloud NAT, and Private Service Access (PSA). |
| **Security & WAF** | `modules/security-waf` | Cloud Armor WAF policy with OWASP Top 10 CRS rules (SQLi, XSS, RCE), client rate limiting, L7 adaptive protection, reserved static global IP, and Google-managed SSL. |
| **Compute GKE** | `modules/compute-gke` | Private GKE Autopilot cluster, Workload Identity configuration, Backup for GKE plan, and scoped IAM roles (`roles/aiplatform.user`, `roles/storage.objectUser`). |
| **Compute Cloud Run** | `modules/compute-cloudrun` | Serverless Cloud Run v2 service with Direct VPC Egress, 0-to-5 autoscaling, `no-cpu-throttling`, 300s timeout, and dedicated Service Account. |
| **Data & AI Foundation** | `modules/data-ai-foundation` | Vertex AI and BigQuery API enablement, BigQuery Lakehouse dataset, Cloud Storage RAG bucket (`versioning`, `UBLA`), and model artifacts bucket. |
| **Bastion Host** | `modules/bastion` | Debian 12 Compute Engine VM with zero external IPs, accessible exclusively via IAP tunnel, pre-configured with `kubectl`, `gke-gcloud-auth-plugin`, `tinyproxy`, and OS Login. |
| **SRE Observability** | `modules/observability` | Cloud Logging sink with polymorphic schema exclusion filter (preventing `table_invalid_schema` errors), partitioned BigQuery dataset, and Cloud Monitoring dashboard. |
| **FinOps Budget** | `modules/finops-budget` | Cloud Billing budget alert with thresholds at 50%, 75%, 90%, 100% actual, and 100% forecasted spend, with direct email notifications. |
| **Backup & DR** | `modules/backup-dr` | Immutable WORM vaults for operational and geo-redundant retention, and Backup for GKE integration for application manifests and persistent volumes. |

---

## Turnkey Architecture Profiles (Reusability)

To streamline reuse across different environments (rapid demonstrations vs sovereign enterprise production), [`terraform.tfvars.example`](file:///usr/local/google/home/hoffmannw/gcp-ai-foundation-blueprint/terraform.tfvars.example) provides two pre-configured profiles:

| Profile | Target Use Case | Compute & Security Configuration | Provisioning Time & Cost |
| :--- | :--- | :--- | :--- |
| **Profile A: Lightweight Serverless Demo** | Fast demos (`app-rag-comparison`), agile PoCs, ephemeral sandboxes. | `enable_cloudrun = true`, `enable_gke = false`, `enable_bastion = false`, `enable_waf = false`, `force_destroy = true`. | **~2 min** / Near-zero idle cost (*scale-to-zero*). |
| **Profile B: Sovereign Enterprise Production** | Enterprise workloads (`app-civiclens`), sensitive data, SecOps/DORA compliance. | `enable_gke = true`, `enable_waf = true`, `enable_bastion = true`, `enable_backup_dr = true`, `deletion_protection = true`. | **~15 min** / Multi-zone HA & WORM retention. |

---

## Root Configuration Variables (`variables.tf`)

The root module exposes 27 strongly typed and validated variables (`validation {}`):

| Variable | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `project_id` | `string` | *Required* | Target Google Cloud project identifier (regex validated). |
| `region` | `string` | `"europe-west1"` | Primary GCP region for networking, compute, and data resources. |
| `zone` | `string` | `"europe-west1-b"` | Primary GCP zone for the Bastion VM. |
| `resource_prefix` | `string` | `"ai-base"` | Naming prefix applied to all provisioned GCP resources. |
| `enable_random_suffix` | `bool` | `true` | Appends a collision-resistant random suffix to resources and GCS buckets. |
| `random_suffix_length` | `number` | `4` | Length of the random suffix (between 2 and 8 characters). |
| `enable_gke` | `bool` | `true` | Provisions the private GKE Autopilot cluster. |
| `enable_cloudrun` | `bool` | `false` | Provisions the serverless Cloud Run v2 service with Direct VPC Egress. |
| `enable_bastion` | `bool` | `true` | Provisions the private IAP administrative bastion VM. |
| `enable_waf` | `bool` | `true` | Provisions the Cloud Armor WAF policy (OWASP Top 10 + Rate Limiting). |
| `excluded_upload_paths` | `list(string)` | `["/api/documents/upload"]` | URL path prefixes excluded from OWASP body inspection (prevents HTTP 403 false positives during PDF/document uploads). |
| `domain_name` | `string` | `""` | Custom domain name for Google-managed SSL certificate (leave empty to skip). |
| `admin_email` | `string` | `""` | Administrator email granted Zero-Trust IAP access (`roles/iap.httpsResourceAccessor`). |
| `enable_observability` | `bool` | `true` | Creates the Cloud Logging BigQuery sink and Cloud Monitoring dashboard. |
| `alert_email` | `string` | `""` | Recipient email address for SRE Cloud Monitoring and FinOps budget alerts. |
| `billing_account` | `string` | `""` | Cloud Billing account ID (enables automated monthly budget alerts). |
| `budget_amount` | `number` | `100` | Target monthly spend cap in project currency (must be > 0). |
| `budget_currency` | `string` | `"USD"` | Currency code for budget alerts (`USD`, `EUR`, etc.). |
| `enable_backup_dr` | `bool` | `false` | Enables the Backup & DR module (WORM vaults and GKE workload backups). |
| `dr_region` | `string` | `"europe-west4"` | Secondary GCP region for geo-redundant DR vaults. |
| `backup_daily_retention_days` | `number` | `7` | Retention duration for daily operational backups (in days). |
| `backup_weekly_retention_weeks` | `number` | `4` | Retention duration for weekly geo-redundant DR backups (in weeks). |
| `enable_geo_dr_vault` | `bool` | `true` | Provisions the secondary cross-region backup vault in `dr_region`. |
| `deletion_protection` | `bool` | `false` | Enables deletion protection on GKE and Cloud Run. Set `true` in production. |
| `force_destroy` | `bool` | `false` | Allows deleting non-empty GCS buckets and BigQuery datasets during `terraform destroy` (useful for demo teardowns). |
| `kms_key_name` | `string` | `""` | Optional Cloud KMS CryptoKey ID (CMEK) for customer-managed encryption on BigQuery and GCS. |
| `labels` | `map(string)` | `{...}` | FinOps labels applied uniformly to all resources via `default_labels`. |

---

## Plug-and-Play Outputs (`outputs.tf`)

Outputs are designed to be injected directly into downstream application deployment scripts (`terraform output -raw <name>`) without manual string parsing:

| Output | Description & Downstream Usage |
| :--- | :--- |
| `vpc_network_name` / `subnet_name` | Short names of the VPC and subnet (for `--network` and `--subnet` with Cloud Run Direct VPC Egress). |
| `external_ip` / `external_ip_name` | External IPv4 address and its resource name (for Kubernetes `ingress.global-static-ip-name` annotation). |
| `waf_policy_id` / `waf_policy_name` | Full URI and short name of the Cloud Armor WAF policy (for GKE `BackendConfig`). |
| `ssl_certificate_name` | Managed SSL certificate name (for Kubernetes `ingress.gcp.kubernetes.io/pre-shared-cert` annotation). |
| `lakehouse_dataset_id` | BigQuery AI Lakehouse dataset ID (`{prefix}_lakehouse`). |
| `rag_bucket_name` / `rag_bucket_url` | Name and `gs://` URL of the Cloud Storage bucket for RAG documents. |
| `artifacts_bucket_name` / `artifacts_bucket_url` | Name and `gs://` URL of the Cloud Storage bucket for AI artifacts and model caches. |
| `gke_cluster_name` / `gke_cluster_endpoint` | Name and private endpoint of the GKE Autopilot cluster. |
| `gke_get_credentials_command` | Ready-to-run `gcloud container clusters get-credentials ... --internal-ip` command. |
| `gke_app_service_account_email` | Google Service Account email configured for GKE Workload Identity. |
| `workload_identity_pool` | Project Workload Identity Pool (`{project_id}.svc.id.goog`). |
| `cloudrun_service_name` / `cloudrun_service_uri` | Name and HTTPS endpoint URI for the Cloud Run v2 service. |
| `cloudrun_service_account_email` | Dedicated Service Account email for the Cloud Run service. |
| `bastion_ssh_command` | `gcloud compute ssh ... --tunnel-through-iap` command to connect to the private bastion. |


---

## Quickstart

### 1. Prerequisites
- Authenticated `gcloud` CLI (`gcloud auth login` and `gcloud auth application-default login`).
- `terraform` version 1.5.0 or higher.
- `roles/owner` or `roles/editor` on the target Google Cloud project.

### 2. Project Bootstrap
Run the bootstrap script to enable required APIs and provision the remote state bucket:

```bash
./scripts/bootstrap.sh <YOUR_PROJECT_ID> europe-west1
```

### 3. Configuration & Deployment

```bash
# 1. Copy the example variables template
cp terraform.tfvars.example terraform.tfvars

# 2. Fill in project_id and admin_email in terraform.tfvars

# 3. Initialize providers and modules
terraform init

# 4. Review execution plan
terraform plan

# 5. Apply infrastructure
terraform apply
```

### 4. Deploying Applications on this Foundation
Once the foundation is provisioned, deploy compatible applications:
- To deploy the RAG comparison demo:
  ```bash
  cd ../app-rag-comparison
  ./scripts/deploy-to-blueprint.sh --blueprint-dir=../gcp-ai-foundation-blueprint
  ```
- Refer to the [Application Integration Guide](docs/APPLICATION_INTEGRATION-EN.md) for custom architectures.

---

## Security & Argolis Compliance

- **Zero compute public IPs**: No GKE nodes, bastion VMs, or serverless containers bind public IP addresses (`constraints/compute.vmExternalIpAccess`).
- **Controlled egress**: Outbound connections (dependency downloads, model weights) are routed exclusively through Cloud NAT.
- **IAP zero-trust administration**: Administrative SSH connections to the bastion VM are restricted to the Google IAP IP range `35.235.240.0/20`.
- **Domain-restricted authorization**: In Cloudtop or developer environments where ADC is subject to domain restrictions, export a temporary access token before running Terraform:
  ```bash
  export GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token --account=user@your-domain.altostrat.com)
  terraform apply
  ```

---

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.
