# Module Data & AI Foundation (`modules/data-ai-foundation`)

Ce module provisionne les briques de données managées et de stockage d'Intelligence Artificielle nécessaires à l'alimentation des LLMs, pipelines RAG (Retrieval-Augmented Generation) et architectures Lakehouse sur Google Cloud.

## 🌟 Fonctionnalités

- **Activation Automatisée des APIs Fondatrices** :
  - `aiplatform.googleapis.com` (Vertex AI, Gemini, Model Garden).
  - `bigquery.googleapis.com` (Moteur d'analytique et indexation vectorielle).
- **BigQuery Lakehouse & Vector Store** :
  - Dataset régionalisé (`location = var.region`) prêt pour les tables partitionnées et les index vectoriels (`VECTOR_SEARCH`).
  - Paramétrage de la durée d'expiration des tables (idéal pour nettoyer automatiquement les données de test en démonstration).
- **Double Bucket Cloud Storage Sécurisé** :
  - **Bucket Documents RAG** (`gs://...-rag-docs`) : Stockage des PDFs, textes, bases documentaires et chunks de données brutes avec versioning activé et configuration CORS pour les interfaces d'upload.
  - **Bucket Modèles & Artefacts** (`gs://...-ai-artifacts`) : Stockage des adaptateurs LoRA, poids de modèles, traces d'évaluation et caches de requêtes avec passage automatique en classe Nearline après 30 jours pour optimiser les coûts.
- **Sécurité du Stockage** :
  - `uniform_bucket_level_access = true` enforcé sur tous les buckets (élimination des ACLs objet fragiles).

## 📥 Entrées (Inputs)

| Nom | Description | Type | Défaut | Requis |
| :--- | :--- | :--- | :--- | :---: |
| `project_id` | ID du projet Google Cloud cible | `string` | - | **Oui** |
| `region` | Région GCP pour le dataset BigQuery et les buckets GCS | `string` | `"europe-west1"` | Non |
| `dataset_id` | Identifiant du dataset BigQuery | `string` | `"ai_lakehouse"` | Non |
| `dataset_friendly_name` | Nom d'affichage du dataset | `string` | `"AI Lakehouse & Vector Store"` | Non |
| `dataset_description` | Description du dataset | `string` | `"..."` | Non |
| `default_table_expiration_ms` | Expiration par défaut des tables en millisecondes | `number` | `null` | Non |
| `delete_contents_on_destroy` | Supprimer les tables du dataset lors d'un `terraform destroy` | `bool` | `false` | Non |
| `rag_bucket_name` | Nom personnalisé pour le bucket RAG (auto-généré si vide) | `string` | `""` | Non |
| `artifacts_bucket_name` | Nom personnalisé pour le bucket Artefacts (auto-généré si vide) | `string` | `""` | Non |
| `cors_allowed_origins` | Origines autorisées pour les requêtes CORS | `list(string)` | `["*"]` | Non |
| `labels` | Labels de ressources à propager | `map(string)` | `{tier = "ai-foundation"}` | Non |

## 📤 Sorties (Outputs)

| Nom | Description |
| :--- | :--- |
| `dataset_id` | Identifiant du dataset BigQuery |
| `dataset_name` | Nom convivial du dataset BigQuery |
| `rag_bucket_name` | Nom du bucket Cloud Storage pour les documents RAG |
| `rag_bucket_url` | URL au format `gs://...` pour les documents RAG |
| `artifacts_bucket_name` | Nom du bucket Cloud Storage pour les modèles et artefacts |
| `artifacts_bucket_url` | URL au format `gs://...` pour les modèles et artefacts |

## 💡 Exemple d'Utilisation

```hcl
module "data_ai" {
  source = "./modules/data-ai-foundation"

  project_id            = "mon-projet-gcp"
  region                = "europe-west1"
  dataset_id            = "mon_lakehouse_rag"
  dataset_friendly_name = "Knowledge Base & Embeddings"
}
```
