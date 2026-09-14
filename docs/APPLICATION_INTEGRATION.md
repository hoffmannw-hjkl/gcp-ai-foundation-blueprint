# Guide d'Intégration Applicative sur le Blueprint 🚀

Ce guide détaille pas-à-pas comment déployer et exécuter **votre propre application d'Intelligence Artificielle** (API REST FastAPI, agent GenAI, pipeline RAG, interface Streamlit, worker d'inférence) sur l'infrastructure provisionnée par le blueprint.

---

## 🧭 Vue d'ensemble du flux de déploiement

```mermaid
flowchart LR
    Dev(["Développeur"]) -->|1. Build & Push| AR["Artifact Registry\n(Docker Image)"]
    Dev -->|2. Tunnel IAP| Bastion["VM Bastion\n(Accès GKE Privé)"]
    Bastion -->|3. kubectl apply| K8s["Cluster GKE Autopilot"]
    
    subgraph K8s_Workload ["Pods Applicatifs (Namespace démo)"]
        Pod["Pod AI Application\n(FastAPI / Streamlit / vLLM)"]
        KSA["K8s Service Account\n(annoté iam.gke.io)"]
        Pod -.-> KSA
    end
    
    KSA ==>|Workload Identity\n(Zéro clé JSON)| GCP_Services["Services Google Cloud\n- Vertex AI (Gemini 2.5/3.6)\n- BigQuery Lakehouse\n- Buckets GCS RAG & Artifacts"]
    
    Ingress["External HTTPS Ingress\n(IP Statique + SSL Managé)"] -->|Cloud Armor WAF| Pod
```

---

## 1. Récupération des Paramètres Terraform

Après avoir exécuté `terraform apply`, récupérez les valeurs clés générées par votre infrastructure :

```bash
# Se placer dans le répertoire du blueprint
cd gcp-ai-foundation-blueprint

# Récupérer les identifiants
PROJECT_ID=$(gcloud config get-value project)
GKE_CLUSTER=$(terraform output -raw gke_cluster_name)
BASTION_CMD=$(terraform output -raw bastion_ssh_command)
RAG_BUCKET=$(terraform output -raw rag_bucket_url)
ARTIFACTS_BUCKET=$(terraform output -raw artifacts_bucket_url)
BQ_DATASET=$(terraform output -raw lakehouse_dataset_id)
WAF_POLICY=$(terraform output -raw waf_policy_id | awk -F'/' '{print $NF}')
GLOBAL_IP=$(terraform output -raw external_ip)
```

Le compte de service Google (GSA) configuré par défaut pour Workload Identity a pour format :
`<name_prefix>-gke-ai-sa@${PROJECT_ID}.iam.gserviceaccount.com`

---

## 2. Option A : Déploiement sur GKE Autopilot (Recommandé)

### Étape 2.1 : Packager et publier votre conteneur

1. Créez un dépôt Docker sur Artifact Registry s'il n'existe pas encore :
   ```bash
   gcloud artifacts repositories create ai-app-repo \
     --repository-format=docker \
     --location=europe-west1 \
     --description="Dépôt d'images pour applications AI" \
     --project="${PROJECT_ID}"
   ```

2. Compilez et poussez votre conteneur avec Google Cloud Build :
   ```bash
   # Depuis la racine de votre projet applicatif contenant un Dockerfile :
   gcloud builds submit \
     --tag "europe-west1-docker.pkg.dev/${PROJECT_ID}/ai-app-repo/my-ai-app:latest" \
     --project="${PROJECT_ID}" \
     .
   ```

---

### Étape 2.2 : Configurer Workload Identity (Zéro Clé JSON)

Le blueprint a déjà associé le Google Service Account (`roles/aiplatform.user`, `roles/bigquery.dataEditor`, `roles/storage.objectViewer`) au compte de service Kubernetes :
- **Namespace Kubernetes** : `default` (ou votre namespace dédié)
- **K8s Service Account (KSA)** : `ai-workload-sa`

Créez le manifest `k8s-service-account.yaml` :

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ai-workload-sa
  namespace: default
  annotations:
    # Lier le compte Kubernetes au compte Google Cloud créé par Terraform
    iam.gke.io/gcp-service-account: "ai-demo-xxxx-gke-ai-sa@VOTRE_PROJECT_ID.iam.gserviceaccount.com"
```

---

### Étape 2.3 : Configurer le BackendConfig (Cloud Armor WAF & IAP)

Pour attacher la politique de sécurité **Cloud Armor WAF** (règles OWASP Top 10 et Rate Limiting) à votre service, créez `backend-config.yaml` :

```yaml
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: ai-app-backend-config
  namespace: default
spec:
  securityPolicy:
    name: "ai-demo-xxxx-waf-policy" # Output Terraform: nom de la waf_policy
```

---

### Étape 2.4 : Déployer l'Application & le Service

Créez `deployment.yaml` en injectant les variables d'environnement pointant vers vos ressources managées :

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
      serviceAccountName: ai-workload-sa  # Workload Identity activé !
      containers:
      - name: app
        image: europe-west1-docker.pkg.dev/VOTRE_PROJECT_ID/ai-app-repo/my-ai-app:latest
        ports:
        - containerPort: 8080
        env:
        - name: GCP_PROJECT
          value: "VOTRE_PROJECT_ID"
        - name: GCP_REGION
          value: "europe-west1"
        - name: RAG_BUCKET
          value: "gs://VOTRE_PROJECT_ID-ai-demo-xxxx-rag-docs"
        - name: ARTIFACTS_BUCKET
          value: "gs://VOTRE_PROJECT_ID-ai-demo-xxxx-artifacts"
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
    cloud.google.com/neg: '{"ingress": true}' # Requis pour GKE Ingress natif
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

### Étape 2.5 : Exposer via l'External Ingress (HTTPS + IP Réservée)

Créez `ingress.yaml` pour lier le Load Balancer externe Google Cloud à votre service :

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ai-app-ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: "gce"
    # Utiliser l'IP statique globale créée par le module security-waf
    kubernetes.io/ingress.global-static-ip-name: "ai-demo-xxxx-global-ip"
spec:
  rules:
  - http:
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

### Étape 2.6 : Appliquer les manifests via le Bastion IAP

Puisque le cluster GKE Autopilot est **100% privé** (Argolis-Ready), déployez vos fichiers depuis le bastion sécurisé via le tunnel IAP :

```bash
# 1. Copier vos manifests sur le Bastion via IAP
gcloud compute scp *.yaml ai-demo-xxxx-bastion:~ \
  --zone=europe-west1-b \
  --project=VOTRE_PROJECT_ID \
  --tunnel-through-iap

# 2. Se connecter au Bastion et appliquer les manifests
gcloud compute ssh ai-demo-xxxx-bastion \
  --zone=europe-west1-b \
  --project=VOTRE_PROJECT_ID \
  --tunnel-through-iap

# (Sur le bastion) :
gcloud container clusters get-credentials ai-demo-xxxx-gke --region europe-west1 --internal-ip
kubectl apply -f k8s-service-account.yaml
kubectl apply -f backend-config.yaml
kubectl apply -f deployment.yaml
kubectl apply -f ingress.yaml

# Vérifier le statut des Pods
kubectl get pods -w
```

---

## 3. Option B : Déploiement sur Cloud Run v2 (Serverless)

Si vous préférez une architecture Serverless avec dimensionnement à zéro :

1. Activez `enable_cloudrun = true` dans votre `terraform.tfvars`.
2. Déployez votre conteneur en le rattachant au **Serverless VPC Access Connector** et au compte de service dédié :
   ```bash
   gcloud run deploy my-ai-service \
     --image="europe-west1-docker.pkg.dev/${PROJECT_ID}/ai-app-repo/my-ai-app:latest" \
     --region="europe-west1" \
     --service-account="ai-demo-xxxx-cr-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
     --vpc-connector="ai-demo-xxxx-vpc-connector" \
     --vpc-egress="private-ranges-only" \
     --set-env-vars="GCP_PROJECT=${PROJECT_ID},BQ_DATASET=ai_demo_xxxx_lakehouse" \
     --no-allow-unauthenticated \
     --project="${PROJECT_ID}"
   ```

---

## 4. Exemple de Code Applicatif Python (SDK `google-genai`)

Grâce à Workload Identity, votre code Python n'a **besoin d'aucun fichier de credentials ni de clé d'API**. Il s'authentifie de manière transparente :

```python
import os
from google import genai
from google.cloud import bigquery, storage

# 1. Initialisation du client Vertex AI (SDK google-genai moderne)
# L'authentification utilise directement le token injecté par Workload Identity
client = genai.Client(
    vertexai=True,
    project=os.getenv("GCP_PROJECT"),
    location=os.getenv("GCP_REGION", "europe-west1")
)

def ask_gemini(prompt: str) -> str:
    """Interroge Gemini 2.5/3.6 sur Vertex AI."""
    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents=prompt
    )
    return response.text

# 2. Interrogation de BigQuery Lakehouse
def query_lakehouse(sql_query: str):
    bq_client = bigquery.Client(project=os.getenv("GCP_PROJECT"))
    return bq_client.query(sql_query).to_dataframe()

# 3. Lecture de documents RAG sur Cloud Storage
def get_rag_document(filename: str) -> str:
    storage_client = storage.Client(project=os.getenv("GCP_PROJECT"))
    bucket = storage_client.bucket(os.getenv("RAG_BUCKET").replace("gs://", ""))
    blob = bucket.blob(filename)
    return blob.download_as_text()

if __name__ == "__main__":
    answer = ask_gemini("Explique les bénéfices de Workload Identity sur GKE en 2 phrases.")
    print("Réponse Gemini :", answer)
```

---

## 5. Vérification & Observabilité

Une fois déployé :
1. **Accédez au Dashboard SRE** : Ouvrez Cloud Monitoring via l'URL `monitoring_dashboard_id` pour observer le CPU/RAM des pods et les requêtes bloquées par Cloud Armor WAF.
2. **Consultez les logs applicatifs dans BigQuery** :
   ```sql
   SELECT timestamp, severity, textPayload
   FROM `VOTRE_PROJECT_ID.ai_demo_xxxx_lakehouse_logs.stdout_*`
   ORDER BY timestamp DESC
   LIMIT 100;
   ```
3. **Surveillez votre consommation** : Le module `finops-budget` vous notifiera automatiquement dès que 50% du budget alloué est atteint.
