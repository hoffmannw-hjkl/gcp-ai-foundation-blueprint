# Application Integration & Workload Deployment Guide 🚀

This guide provides a step-by-step walkthrough on how to deploy and run **your own Artificial Intelligence applications** (FastAPI backend, GenAI agent, RAG pipeline, Streamlit UI, vLLM inference worker) on top of the infrastructure provisioned by this blueprint.

> 🌟 **Full Production Reference Implementation: [CivicLens](https://github.com/cloud-gtm/civiclens)**
> To see this deployment pattern implemented in a large-scale real-world AI application combining GKE Autopilot, Cloud SQL PostgreSQL with `pgvector`, Gemini multimodality, and full IAP authentication, explore the companion repository **[CivicLens (cloud-gtm/civiclens)](https://github.com/cloud-gtm/civiclens)**.

---

## 🧭 Deployment Workflow Overview

```mermaid
flowchart LR
    Dev(["Developer"]) -->|1. Build & Push| AR["Artifact Registry\n(Docker Image)"]
    Dev -->|2. IAP Tunnel| Bastion["Bastion VM\n(Private GKE Access)"]
    Bastion -->|3. kubectl apply| K8s["GKE Autopilot Cluster"]
    
    subgraph K8s_Workload ["Application Pods (Workload Namespace)"]
        Pod["AI App Pod\n(FastAPI / Streamlit / vLLM)"]
        KSA["K8s Service Account\n(annotated iam.gke.io)"]
        Pod -.-> KSA
    end
    
    KSA ==>|Workload Identity\n(Zero JSON keys)| GCP_Services["Google Cloud Services\n- Vertex AI (Gemini 2.5/3.6)\n- BigQuery Lakehouse\n- GCS RAG & Artifacts Buckets"]
    
    Ingress["External HTTPS Ingress\n(Static Global IP + Managed SSL)"] -->|Cloud Armor WAF| Pod
```

---

## 1. Retrieve Terraform Outputs

After running `terraform apply`, extract the resource identifiers and endpoints directly without manual string parsing:

```bash
cd gcp-ai-foundation-blueprint

PROJECT_ID=$(gcloud config get-value project)
GKE_CLUSTER=$(terraform output -raw gke_cluster_name)
GKE_GSA=$(terraform output -raw gke_app_service_account_email)
CLOUDRUN_SA=$(terraform output -raw cloudrun_service_account_email)
VPC_NETWORK=$(terraform output -raw vpc_network_name)
SUBNET_NAME=$(terraform output -raw subnet_name)
BASTION_CMD=$(terraform output -raw bastion_ssh_command)
RAG_BUCKET=$(terraform output -raw rag_bucket_name)
ARTIFACTS_BUCKET=$(terraform output -raw artifacts_bucket_name)
BQ_DATASET=$(terraform output -raw lakehouse_dataset_id)
WAF_POLICY=$(terraform output -raw waf_policy_name)
GLOBAL_IP_NAME=$(terraform output -raw external_ip_name)
```

---


## 2. Option A: Deploy on GKE Autopilot (Recommended)

### Step 2.1: Package and Publish Your Container

1. Create a Docker repository in Artifact Registry if not already present:
   ```bash
   gcloud artifacts repositories create ai-app-repo \
     --repository-format=docker \
     --location=europe-west1 \
     --description="Docker repository for AI applications" \
     --project="${PROJECT_ID}"
   ```

2. Build and push your container image using Google Cloud Build:
   ```bash
   # From your application directory containing a Dockerfile:
   gcloud builds submit \
     --tag "europe-west1-docker.pkg.dev/${PROJECT_ID}/ai-app-repo/my-ai-app:latest" \
     --project="${PROJECT_ID}" \
     .
   ```

---

### Step 2.2: Configure Workload Identity (Zero JSON Keys)

The blueprint automatically maps the Google Service Account (`roles/aiplatform.user`, `roles/bigquery.dataEditor`, `roles/storage.objectViewer`) to the Kubernetes Service Account:
- **Kubernetes Namespace**: `default` (or custom namespace)
- **K8s Service Account (KSA)**: `ai-workload-sa`

Create `k8s-service-account.yaml`:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ai-workload-sa
  namespace: default
  annotations:
    iam.gke.io/gcp-service-account: "ai-demo-xxxx-gke-ai-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com"
```

---

### Step 2.3: Configure BackendConfig (Cloud Armor WAF)

Attach the **Cloud Armor WAF** policy (OWASP Top 10 rules and Rate Limiting) via `backend-config.yaml`:

```yaml
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: ai-app-backend-config
  namespace: default
spec:
  securityPolicy:
    name: "ai-demo-xxxx-waf-policy" # Terraform output: waf_policy_id (short name)
```

---

### Step 2.4: Deploy the Application & Service

Create `deployment.yaml` injecting managed resource environment variables:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-ai-app
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-ai-app
  template:
    metadata:
      labels:
        app: my-ai-app
    spec:
      serviceAccountName: ai-workload-sa  # Workload Identity enabled!
      containers:
      - name: app
        image: europe-west1-docker.pkg.dev/YOUR_PROJECT_ID/ai-app-repo/my-ai-app:latest
        ports:
        - containerPort: 8080
        env:
        - name: GCP_PROJECT
          value: "YOUR_PROJECT_ID"
        - name: GCP_REGION
          value: "europe-west1"
        - name: RAG_BUCKET
          value: "gs://YOUR_PROJECT_ID-ai-demo-xxxx-rag-docs"
        - name: ARTIFACTS_BUCKET
          value: "gs://YOUR_PROJECT_ID-ai-demo-xxxx-artifacts"
        - name: BQ_DATASET
          value: "ai_demo_xxxx_lakehouse"
        resources:
          requests:
            cpu: "500m"
            memory: "1Gi"
          limits:
            cpu: "2"
            memory: "4Gi"
---
apiVersion: v1
kind: Service
metadata:
  name: my-ai-service
  namespace: default
  annotations:
    cloud.google.com/backend-config: '{"default": "ai-app-backend-config"}'
    cloud.google.com/neg: '{"ingress": true}' # Required for native GKE Ingress
spec:
  type: ClusterIP
  selector:
    app: my-ai-app
  ports:
  - port: 80
    targetPort: 8080
    name: http
```

---

### Step 2.5: DNS Record (Cloud DNS) & Google-managed SSL Certificate
 
To expose your service under a custom domain (e.g., `my-app.hoffmannw.demo.altostrat.com`) with automated HTTPS termination:
 
#### A. Create DNS A Record (Cloud DNS)
Point an `A` record to the reserved static global external IP (`external_ip`) generated by Terraform:
 
```bash
# Example via gcloud CLI (in the project hosting your Cloud DNS zone):
gcloud dns record-sets create "my-app.your-domain.demo.altostrat.com." \
  --zone="your-dns-zone" \
  --type="A" \
  --ttl=60 \
  --rrdatas="YOUR_STATIC_GLOBAL_IP" \
  --project="dns-project-id"
```
 
*Note: You can also manage this via Terraform (CivicLens pattern):*
```hcl
resource "google_dns_record_set" "app_a_record" {
  project      = "dns-project-id"
  managed_zone = "your-zone"
  name         = "my-app.your-domain.demo.altostrat.com."
  type         = "A"
  ttl          = 60
  rrdatas      = [module.security_waf[0].external_ip_address]
}
```
 
#### B. Google Managed SSL Certificate (`ManagedCertificate`)
Create `managed-cert.yaml` to request a free Google-managed SSL certificate:
 
```yaml
apiVersion: networking.gke.io/v1
kind: ManagedCertificate
metadata:
  name: ai-app-managed-cert
  namespace: default
spec:
  domains:
    - "my-app.your-domain.demo.altostrat.com"
```
 
---
 
### Step 2.6: Expose via External Ingress (HTTPS + Static IP + SSL Cert)
 
Create or adapt `ingress.yaml` to configure the Google Cloud HTTP(S) Load Balancer:
 
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ai-app-ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: "gce"
    kubernetes.io/ingress.global-static-ip-name: "ai-demo-xxxx-global-ip"
    networking.gke.io/managed-certificates: "ai-app-managed-cert"
    kubernetes.io/ingress.allow-http: "true"
spec:
  rules:
  - host: "my-app.your-domain.demo.altostrat.com"
    http:
      paths:
      - path: /*
        pathType: ImplementationSpecific
        backend:
          service:
            name: my-ai-service
            port:
              name: http
```
 
---
 
### Step 2.7: Apply Manifests via the IAP Bastion

Because the GKE Autopilot cluster is **100% private** (Argolis compliant), deploy your manifests through the secure IAP Bastion:

```bash
# 1. Copy manifests to the Bastion VM via IAP
gcloud compute scp *.yaml ai-demo-xxxx-bastion:~ \
  --zone=europe-west1-b \
  --project=YOUR_PROJECT_ID \
  --tunnel-through-iap

# 2. SSH into the Bastion and apply
gcloud compute ssh ai-demo-xxxx-bastion \
  --zone=europe-west1-b \
  --project=YOUR_PROJECT_ID \
  --tunnel-through-iap

# (Inside Bastion):
gcloud container clusters get-credentials ai-demo-xxxx-gke --region europe-west1 --internal-ip
kubectl apply -f k8s-service-account.yaml
kubectl apply -f backend-config.yaml
kubectl apply -f deployment.yaml
kubectl apply -f ingress.yaml

kubectl get pods -w
```

---

## 3. Option B: Deploy on Cloud Run v2 (Serverless — Direct VPC Egress)

For serverless scale-to-zero workloads (*Profile A*):

1. Enable `enable_cloudrun = true` in `terraform.tfvars`.
2. Deploy the container bound directly to the VPC via **Direct VPC Egress** and the dedicated Service Account:
   ```bash
   gcloud run deploy my-ai-service \
     --image="europe-west1-docker.pkg.dev/${PROJECT_ID}/ai-app-repo/my-ai-app:latest" \
     --region="europe-west1" \
     --service-account="${CLOUDRUN_SA}" \
     --network="${VPC_NETWORK}" \
     --subnet="${SUBNET_NAME}" \
     --vpc-egress="all-traffic" \
     --set-env-vars="GCP_PROJECT=${PROJECT_ID},BQ_DATASET=${BQ_DATASET},GCS_BUCKET=${RAG_BUCKET}" \
     --no-allow-unauthenticated \
     --project="${PROJECT_ID}"
   ```

---


## 4. Python Application Code Example (`google-genai` SDK)

Workload Identity seamlessly provisions OAuth credentials into the application runtime:

```python
import os
from google import genai
from google.cloud import bigquery, storage

# 1. Vertex AI client initialization using ambient Workload Identity credentials
client = genai.Client(
    vertexai=True,
    project=os.getenv("GCP_PROJECT"),
    location=os.getenv("GCP_REGION", "europe-west1")
)

def ask_gemini(prompt: str) -> str:
    """Invokes Gemini 2.5/3.6 on Vertex AI."""
    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents=prompt
    )
    return response.text

# 2. BigQuery Lakehouse query
def query_lakehouse(sql_query: str):
    bq_client = bigquery.Client(project=os.getenv("GCP_PROJECT"))
    return bq_client.query(sql_query).to_dataframe()

# 3. Retrieve RAG documents from GCS
def get_rag_document(filename: str) -> str:
    storage_client = storage.Client(project=os.getenv("GCP_PROJECT"))
    bucket = storage_client.bucket(os.getenv("RAG_BUCKET").replace("gs://", ""))
    blob = bucket.blob(filename)
    return blob.download_as_text()

if __name__ == "__main__":
    answer = ask_gemini("Explain Workload Identity benefits on GKE in two sentences.")
    print("Gemini response:", answer)
```
