# GCP AI Foundation Blueprint 🏛️⚡

> **Modular, secure, and reusable Terraform infrastructure baseline for all Artificial Intelligence demonstrations on Google Cloud (Elevate & Spark Programs).**

This repository provides an enterprise-ready, application-agnostic **Landing Zone & Baseline**. It adheres to **Google Cloud Well-Architected** best practices, complies with **Argolis governance constraints**, and enforces enterprise security standards (**Zero Trust, WAF, Least Privilege, SRE schema resilience**).

---

## 🎯 Purpose

During customer demonstrations, proofs of concept (POCs), or acceleration programs (Elevate, Spark, Hackathons), rebuilding networking, NAT gateways, Kubernetes clusters, Cloud Armor WAF rules, and logging pipelines wastes valuable time and introduces configuration drift.

This blueprint solves that challenge by providing:
1. **Modular Architecture**: Separate modules for Networking, WAF, Compute (GKE / Cloud Run), Bastion, Data/AI Foundation, and Observability.
2. **Argolis Ready**: Zero public IPs on compute instances or Kubernetes nodes, private egress via Cloud NAT, and secure access via Identity-Aware Proxy (IAP).
3. **Enterprise Edge Security**: Cloud Armor WAF with OWASP Top 10 Core Rule Set (SQLi, XSS, RCE...), adaptive rate limiting, and Layer 7 ML protection.
4. **Data & AI Baseline**: BigQuery Lakehouse, secure Cloud Storage buckets (UBLA, versioning) for RAG documents and models, and Workload Identity with `roles/aiplatform.user` and `roles/bigquery.dataEditor`.
5. **Hardened Observability**: Cloud Logging sink to BigQuery protected against schema drift (`table_invalid_schema`) caused by system pods, paired with a unified Cloud Monitoring cockpit.

---

## 📁 Repository Structure

```text
.
├── GEMINI.md                     # Development guidelines & Git sync cadence
├── README.md                     # Documentation (French)
├── README-EN.md                  # Documentation (English)
├── main.tf                       # Root Terraform module orchestrating the baseline
├── variables.tf                  # Configuration variables (region, prefix, feature flags)
├── outputs.tf                    # Endpoints, IPs, and resource identifiers
├── versions.tf                   # Minimal Terraform & Google provider versions
├── terraform.tfvars.example      # Example values template
│
├── modules/
│   ├── networking/               # VPC, Subnets, Secondary Ranges, Cloud NAT, PSA, Firewall
│   ├── security-waf/             # Cloud Armor WAF (OWASP Top 10, Rate Limiting), Static IP, SSL
│   ├── compute-gke/              # Private GKE Autopilot, Workload Identity, Least-Privilege IAM
│   ├── compute-cloudrun/         # Cloud Run v2, Serverless VPC Access Connector, Dedicated SA
│   ├── bastion/                  # Private Debian 12 Bastion VM, IAP, OS Login, kubectl
│   ├── data-ai-foundation/       # Vertex AI, BigQuery Lakehouse, GCS RAG & Artifacts Buckets
│   └── observability/            # BigQuery Log Sink (schema resilience filter), Dashboard
│
├── examples/
│   ├── 01-minimal-cloudrun-ai/   # Fast (<3 min) Serverless Cloud Run + WAF prototype
│   └── 02-enterprise-gke-rag/    # Enterprise Landing Zone: GKE Autopilot + Bastion + RAG + SRE
│
├── scripts/
│   ├── bootstrap.sh              # GCP API enablement and Terraform state bucket creation
│   └── sync-gtm.sh               # Git synchronization to official cloud-gtm repository
│
└── .github/workflows/
    └── terraform-lint.yml        # CI/CD: syntax check, formatting, and validation
```

---

## 🚀 Quick Start

### 1. Prerequisites
- `gcloud` CLI authenticated (`gcloud auth login` and `gcloud auth application-default login`).
- `terraform` (v1.5.0 or higher).
- `roles/owner` or `roles/editor` on target GCP project (Argolis or Sandbox).

### 2. Project Bootstrap
Run the bootstrap script to enable required APIs and provision the GCS state bucket:

```bash
./scripts/bootstrap.sh <YOUR_PROJECT_ID> europe-west1
```

### 3. Configure Variables
Copy the example variables file and adjust for your environment:

```bash
cp terraform.tfvars.example terraform.tfvars
```

### 4. Deploy

```bash
terraform init
terraform plan
terraform apply
```

---

## 📄 License
Apache License 2.0. See [LICENSE](LICENSE) for details.
