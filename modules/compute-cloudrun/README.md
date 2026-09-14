# Module Compute Cloud Run (`modules/compute-cloudrun`)

Ce module fournit une infrastructure d'exécution **Serverless** basée sur **Cloud Run v2**, idéale pour déployer rapidement des prototypes d'IA, des microservices d'inférence, des APIs FastAPI/Flask ou des tableaux de bord Streamlit sans la complexité opérationnelle d'un orchestrateur complet.

## 🌟 Fonctionnalités

- **Connecteur Serverless VPC Access** :
  - Raccorde le conteneur serverless au réseau VPC privé via un bloc d'adresses dédié (ex: `10.8.0.0/28`).
  - Permet à Cloud Run d'interroger en toute sécurité des bases de données internes (Cloud SQL, pgvector) et d'utiliser le Cloud NAT pour l'egress.
- **Scale-to-Zero & Économies FinOps** :
  - `min_instance_count = 0` par défaut : Aucun coût de calcul lorsque l'application ne reçoit pas de requêtes.
- **Compte de Service Dédié & Moindre Privilège** :
  - Liaison automatique des permissions pour Vertex AI (`roles/aiplatform.user`), BigQuery (`roles/bigquery.dataEditor`, `roles/bigquery.jobUser`), et Cloud Storage.
- **Paramétrage des Ressources de Calcul** :
  - Allocation fine de la mémoire et des vCPUs pour gérer la charge des modèles de langage et pipelines d'embedding.

## 📥 Entrées (Inputs)

| Nom | Description | Type | Défaut | Requis |
| :--- | :--- | :--- | :--- | :---: |
| `project_id` | ID du projet Google Cloud cible | `string` | - | **Oui** |
| `region` | Région GCP pour le service et le connecteur VPC | `string` | `"europe-west1"` | Non |
| `service_name` | Nom du service Cloud Run | `string` | `"ai-service"` | Non |
| `container_image` | Image de conteneur à déployer | `string` | `"us-docker.pkg.dev/cloudrun/container/hello"` | Non |
| `container_port` | Port d'écoute du conteneur | `number` | `8080` | Non |
| `cpu` | Nombre de vCPUs par instance (ex: 1, 2, 4) | `string` | `"2"` | Non |
| `memory` | Mémoire par instance (ex: 1Gi, 2Gi, 4Gi) | `string` | `"2Gi"` | Non |
| `min_instance_count` | Nombre minimum d'instances (0 pour scale-to-zero) | `number` | `0` | Non |
| `max_instance_count` | Nombre maximum d'instances pour l'auto-scaling | `number` | `10` | Non |
| `ingress_settings` | Paramètre d'ingress (ALL, INTERNAL, INTERNAL_LB) | `string` | `"INGRESS_TRAFFIC_ALL"` | Non |
| `allow_unauthenticated` | Autoriser les invocations publiques sans token IAM | `bool` | `false` | Non |
| `env_vars` | Variables d'environnement pour le conteneur | `map(string)` | `{}` | Non |
| `enable_vpc_connector` | Activer le connecteur Serverless VPC Access | `bool` | `true` | Non |
| `vpc_network_name` | Nom du réseau VPC auquel raccorder le connecteur | `string` | `""` | Non |
| `vpc_connector_cidr` | Plage /28 dédiée au connecteur VPC | `string` | `"10.8.0.0/28"` | Non |
| `vpc_connector_id` | ID d'un connecteur existant (si déjà provisionné) | `string` | `""` | Non |

## 📤 Sorties (Outputs)

| Nom | Description |
| :--- | :--- |
| `service_id` | Identifiant du service Cloud Run |
| `service_name` | Nom du service Cloud Run |
| `service_uri` | URL HTTPS du point de terminaison du service |
| `service_account_email` | Email du compte de service dédié |
| `vpc_connector_id` | Identifiant du connecteur Serverless VPC Access |

## 💡 Exemple d'Utilisation

```hcl
module "fast_api" {
  source = "./modules/compute-cloudrun"

  project_id           = "mon-projet-gcp"
  region               = "europe-west1"
  service_name         = "rag-fastapi"
  vpc_network_name     = module.networking.network_name
  container_image      = "europe-west1-docker.pkg.dev/mon-projet-gcp/apps/rag-api:v1"
  allow_unauthenticated = false
}
```
