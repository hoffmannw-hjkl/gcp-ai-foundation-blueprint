# Exemple 01 : Minimal Cloud Run AI

Cet exemple déploie une architecture AI Serverless minimale, rapide à instancier (< 3 minutes) et particulièrement économique pour les démonstrations et POCs :

- **Réseau** : VPC privé avec Cloud NAT et connecteur Serverless VPC Access.
- **Sécurité** : Politique Cloud Armor WAF (OWASP Top 10 + Rate Limiting).
- **Compute** : Service Cloud Run v2 (scale-to-zero) relié au VPC avec compte de service dédié et rôles IAM Vertex AI.
- **Data** : Dataset BigQuery managé pour l'analytique et les embeddings.

## Déploiement

```bash
terraform init
terraform apply -var="project_id=VOTRE_PROJECT_ID"
```
