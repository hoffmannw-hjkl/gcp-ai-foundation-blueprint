# Exemple 02 : Enterprise GKE RAG Landing Zone

Cet exemple déploie une zone d'atterrissage complète et hautement sécurisée pour des applications GenAI d'entreprise, des systèmes RAG (Retrieval-Augmented Generation) et des plateformes d'agents autonomes :

- **Réseau** : VPC avec plages secondaires pour Pods/Services, Cloud Router, Cloud NAT, et Private Service Access (PSA).
- **Sécurité Edge & Zero Trust** : Cloud Armor WAF (CRS OWASP Top 10 + Rate Limiting), IP statique globale, certificat SSL managé Google, accès Zero Trust IAP.
- **Compute** : Cluster GKE Autopilot privé, sans adresse IP externe sur les nœuds, avec Workload Identity configuré pour Vertex AI et BigQuery.
- **Administration** : Bastion Linux privé accessible uniquement via tunnel IAP (OS Login activé, kubectl et gke-gcloud-auth-plugin préinstallés).
- **Data & AI** : Dataset BigQuery Lakehouse pour le stockage de vecteurs et embeddings, double bucket GCS (Documents RAG & Artefacts IA).
- **Observabilité** : Sink Cloud Logging avec filtre de résilience de schéma (`table_invalid_schema`), alertes SRE et Cockpit unifié Cloud Monitoring.

## Déploiement

```bash
terraform init
terraform apply -var="project_id=VOTRE_PROJECT_ID" -var="admin_email=votre-email@example.com"
```
