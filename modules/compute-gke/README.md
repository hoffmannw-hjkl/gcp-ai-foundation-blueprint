# Module Compute GKE (`modules/compute-gke`)

Ce module déploie un cluster **Google Kubernetes Engine (GKE) Autopilot** privé, conforme aux standards de gouvernance Argolis et conçu pour exécuter des charges de travail d'Intelligence Artificielle générative, des pipelines RAG et des agents autonomes.

## 🌟 Fonctionnalités

- **Mode Autopilot Managé** : Dimensionnement automatique, patching et gestion sans tracas des nœuds de calcul.
- **Cluster 100% Privé (Argolis Ready)** :
  - `enable_private_nodes = true` : Aucun nœud Kubernetes ne possède d'adresse IP externe.
  - Toutes les communications sortantes vers Internet (téléchargement d'images de conteneurs, modèles ou packages) transitent par le Cloud NAT.
- **Master Authorized Networks** :
  - Restreint l'accès au plan de contrôle Kubernetes aux seules plages CIDR internes autorisées (VPC et Bastion).
- **Workload Identity Google Cloud** :
  - Établit une liaison cryptographique sécurisée entre le compte de service Kubernetes (KSA) et le compte de service Google (GSA).
  - Élimine le besoin de clés JSON statiques téléchargées.
- **Rôles IAM Moindre Privilège** :
  - `roles/aiplatform.user` : Permet l'inférence via Vertex AI (Gemini 2.5/3.6, Embeddings, Model Garden).
  - `roles/bigquery.dataEditor` et `roles/bigquery.jobUser` : Permet de requêter et d'écrire dans le Lakehouse BigQuery (recherche vectorielle).
  - `roles/storage.objectViewer` : Permet de charger des documents de référence pour le RAG.
  - `roles/logging.logWriter` et `roles/monitoring.metricWriter` : Observabilité native.

## 📥 Entrées (Inputs)

| Nom | Description | Type | Défaut | Requis |
| :--- | :--- | :--- | :--- | :---: |
| `project_id` | ID du projet Google Cloud cible | `string` | - | **Oui** |
| `region` | Région GCP pour le cluster GKE | `string` | `"europe-west1"` | Non |
| `cluster_name` | Nom du cluster GKE Autopilot | `string` | `"ai-foundation-gke"` | Non |
| `network_id` | ID ou self_link du réseau VPC | `string` | - | **Oui** |
| `subnet_id` | ID ou self_link du sous-réseau primaire | `string` | - | **Oui** |
| `pods_secondary_range_name` | Nom de la plage secondaire pour les Pods | `string` | `"gke-pods"` | Non |
| `services_secondary_range_name` | Nom de la plage secondaire pour les Services | `string` | `"gke-services"` | Non |
| `master_ipv4_cidr_block` | Bloc CIDR /28 dédié au plan de contrôle privé | `string` | `"172.16.254.0/28"` | Non |
| `enable_private_endpoint` | Utiliser uniquement l'endpoint privé pour le master | `bool` | `false` | Non |
| `master_authorized_cidr_blocks` | Liste des blocs CIDR autorisés pour `kubectl` | `list(object)` | `[{cidr_block = "10.0.0.0/8", display_name = "internal-vpc-and-bastion"}]` | Non |
| `kubernetes_namespace` | Namespace Kubernetes pour la liaison Workload Identity | `string` | `"default"` | Non |
| `kubernetes_service_account` | Nom du Service Account Kubernetes (KSA) | `string` | `"ai-workload-sa"` | Non |
| `deletion_protection` | Protection contre la suppression accidentelle | `bool` | `false` | Non |
| `enable_gke_backup` | Activer l'agent et le plan de sauvegarde GKE Backup | `bool` | `false` | Non |

## 📤 Sorties (Outputs)

| Nom | Description |
| :--- | :--- |
| `cluster_id` | Identifiant du cluster GKE |
| `cluster_name` | Nom du cluster GKE |
| `cluster_endpoint` | Adresse IP du point de terminaison du plan de contrôle |
| `cluster_ca_certificate` | Certificat CA du cluster (sensible) |
| `workload_service_account_email` | Email du Google Service Account Workload Identity |
| `workload_service_account_name` | Nom du Google Service Account Workload Identity |

## 💡 Exemple d'Utilisation

```hcl
module "gke" {
  source = "./modules/compute-gke"

  project_id                    = "mon-projet-gcp"
  region                        = "europe-west1"
  cluster_name                  = "mon-cluster-ia"
  network_id                    = module.networking.network_id
  subnet_id                     = module.networking.subnet_id
  pods_secondary_range_name     = module.networking.pods_secondary_range_name
  services_secondary_range_name = module.networking.services_secondary_range_name
}
```
