# Manifests Kubernetes d'Exemple pour Application AI 📦

Ce répertoire contient un ensemble complet de manifests Kubernetes prêts à l'emploi pour déployer un workload d'IA sur le cluster GKE Autopilot provisionné par le blueprint.

---

## 📄 Liste des Manifests

1. **`01-service-account.yaml`** : Déclare le compte de service Kubernetes (`ai-workload-sa`) annoté avec le Google Service Account pour activer **Workload Identity**.
2. **`02-backend-config.yaml`** : Configure le `BackendConfig` GKE pour lier la politique **Cloud Armor WAF** (OWASP Top 10 et Rate Limiting) au service.
3. **`03-deployment.yaml`** : Déploie les pods avec les variables d'environnement pointant vers Vertex AI, BigQuery Lakehouse et les buckets RAG.
4. **`04-service.yaml`** : Expose le déploiement en ClusterIP avec NEG natif (`cloud.google.com/neg: '{"ingress": true}'`).
5. **`05-managed-cert.yaml`** : Demande un certificat SSL/TLS gratuit géré et renouvelé automatiquement par Google Cloud (`ManagedCertificate`).
6. **`05-ingress.yaml`** : Crée le Google Cloud HTTP(S) Load Balancer avec l'IP statique globale réservée par Terraform et le certificat SSL.

---

## 🚀 Déploiement Rapide en 2 minutes

### 1. Adapter les placeholders
Remplacez les placeholders dans les fichiers par vos valeurs réelles (issues de `terraform output`) :
- `VOTRE_PROJECT_ID` : votre identifiant de projet Google Cloud
- `ai-demo-xxxx` : le préfixe généré par Terraform (visible dans `terraform output`)

### 2. Déployer depuis le Bastion IAP
Puisque le cluster GKE est privé :

```bash
# 1. Copier les manifests sur le Bastion via IAP
gcloud compute scp *.yaml ai-demo-xxxx-bastion:~ --zone=europe-west1-b --tunnel-through-iap

# 2. Se connecter au Bastion
gcloud compute ssh ai-demo-xxxx-bastion --zone=europe-west1-b --tunnel-through-iap

# 3. Récupérer les identifiants du cluster et appliquer
gcloud container clusters get-credentials ai-demo-xxxx-gke --region europe-west1 --internal-ip
kubectl apply -f 01-service-account.yaml
kubectl apply -f 02-backend-config.yaml
kubectl apply -f 03-deployment.yaml
kubectl apply -f 04-service.yaml
kubectl apply -f 05-ingress.yaml

# 4. Observer le statut des pods et les logs
kubectl get pods
kubectl logs -l app=sample-ai-app
```
