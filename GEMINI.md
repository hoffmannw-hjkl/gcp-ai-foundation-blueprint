# Directives Projet GCP AI Foundation Blueprint - Jetski Pair Programming

## Objectif du Référentiel
Fournir une fondation d'infrastructure Terraform (Landing Zone / Baseline) standardisée, sécurisée et réutilisable pour toutes les démonstrations d'Intelligence Artificielle sur Google Cloud (programmes Elevate & Spark).
Ce socle est agnostique du code applicatif et respecte les meilleures pratiques Google Cloud Well-Architected, les contraintes Argolis et les règles de sécurité d'entreprise (Zero Trust, WAF, Least Privilege).

## Règle de Synchronisation Git & Pull Requests (GTM)

- **Dépôt personnel (`github`)** : `https://github.com/hoffmannw-hjkl/gcp-ai-foundation-blueprint` (push direct sur `main`).
- **Dépôt officiel (`gtm`)** : `https://github.com/cloud-gtm/gcp-ai-foundation-blueprint` (dès que le dépôt est créé via go/gtm-github-request). Les modifications sur `gtm` doivent impérativement passer par une Pull Request.
- **Cadence des PRs** :
  - Commits réguliers et atomiques pour chaque étape logique.
  - Tous les ~5 commits (ou lors de la finalisation d'un module/étape importante), exécuter le script `./scripts/sync-gtm.sh` (ou `./scripts/sync-gtm.sh --force`).
  - Le script gère la synchronisation bidirectionnelle, la création de la PR temporaire sur `gtm` et le merge propre.

## Standards d'Architecture & Best Practices

1. **Argolis-Ready** :
   - Aucun composant ne doit requérir d'IP publique directe sur les machines virtuelles ou les nœuds Kubernetes (`constraints/compute.vmExternalIpAccess`).
   - Accès sortant sécurisé via Cloud NAT et Cloud Router.
   - Accès administratif privé via IAP (Identity-Aware Proxy) et Bastion OS Login.
   - Domaines DNS alignés sur la convention Argolis (`*.demo.altostrat.com` ou zones Cloud DNS managées).

2. **Sécurité Edge & WAF** :
   - Cloud Armor configuré avec règles de base OWASP Top 10 (SQLi, XSS, RFI, LFI, RCE).
   - Rate limiting adaptatif (anti-DDoS applicatif et protection anti-bruteforce).
   - External HTTPS Load Balancer avec certificats managés par Google et backend IAP OAuth2.

3. **Data & AI Stack Baseline** :
   - Vertex AI activé avec permissions IAM Least Privilege (Workload Identity pour GKE / Service Account pour Cloud Run).
   - BigQuery Lakehouse partitionné et clusterisé, avec chiffrement et protection des tables.
   - Cloud Storage avec versioning, chiffrement et Uniform Bucket-Level Access (UBLA).

4. **Observabilité SRE** :
   - Sink Cloud Logging vers BigQuery avec filtres d'exclusion stricts (notamment contre les dérives de schéma `table_invalid_schema` des pods système GKE).
   - Dashboards Cloud Monitoring et alertes de budget/latence préconfigurés.
