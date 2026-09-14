# Module Observability (`modules/observability`)

Ce module provisionne une suite d'observabilité de niveau SRE (Site Reliability Engineering) comprenant un exporteur centralisé des logs vers BigQuery, des alertes de détection d'erreurs et un tableau de bord graphique unifié dans Cloud Monitoring.

## 🌟 Fonctionnalités

- **Sink Cloud Logging vers BigQuery Durci contre les Dérives de Schéma** :
  - **Problème résolu** : Sur les environnements Kubernetes (GKE), les conteneurs système (`kube-system`, `gke-gmp-system`, plugins CNI) écrivent des objets JSON polymorphes (notamment `jsonPayload.address` sous forme de chaîne de caractères dans certains logs et de structure/record dans d'autres). Lorsque ces logs arrivent dans BigQuery, ils provoquent une erreur bloquante **`table_invalid_schema: This field: address is not a record`**, interrompant l'ingestion de tous les logs.
  - **Filtre de résilience appliqué** :
    ```text
    severity >= DEFAULT
    AND NOT (jsonPayload.plugins.ipam.ranges:*)
    AND NOT (resource.type="k8s_container" AND (resource.labels.namespace_name="kube-system" OR resource.labels.namespace_name="gke-gmp-system"))
    AND NOT (jsonPayload.address:*)
    ```
- **Dataset BigQuery Partitionné** :
  - Ingestion dans des tables partitionnées par jour (`use_partitioned_tables = true`) pour optimiser les performances de requêtage SQL et réduire les coûts d'analyse.
  - Rétention automatique configurée par défaut à 90 jours.
- **Politique d'Alerte Automatisée** :
  - Détection proactive des dégradations de service lorsque le taux d'erreurs HTTP 5xx dépasse 5% sur une fenêtre de 5 minutes.
  - Canaux de notification par email.
- **Cockpit Unifié Cloud Monitoring** :
  - Visualisation en temps réel de :
    - L'utilisation CPU et mémoire des conteneurs GKE et révisions Cloud Run.
    - La répartition des codes d'état HTTP en entrée du Load Balancer et WAF (2xx, 4xx, 5xx).
    - Les temps de réponse et latences applicatives P95 / P99 (ms).
    - L'évolution de l'espace de stockage consommé par les documents RAG dans Cloud Storage.

## 📥 Entrées (Inputs)

| Nom | Description | Type | Défaut | Requis |
| :--- | :--- | :--- | :--- | :---: |
| `project_id` | ID du projet Google Cloud cible | `string` | - | **Oui** |
| `region` | Région GCP pour le dataset BigQuery de logs | `string` | `"europe-west1"` | Non |
| `enable_log_sink` | Activer l'export Cloud Logging vers BigQuery | `bool` | `true` | Non |
| `sink_name` | Nom du sink Cloud Logging | `string` | `"ai-foundation-log-sink"` | Non |
| `create_log_dataset` | Créer un nouveau dataset BigQuery pour les logs | `bool` | `true` | Non |
| `log_dataset_name` | Nom du dataset BigQuery de logs | `string` | `"ai_foundation_logs"` | Non |
| `existing_bigquery_dataset_id` | ID de dataset existant (si `create_log_dataset = false`) | `string` | `""` | Non |
| `log_filter` | Requête de filtre d'exclusion des logs | `string` | *(voir ci-dessus)* | Non |
| `alert_email_address` | Email pour la réception des alertes SRE | `string` | `""` | Non |
| `enable_dashboard` | Provisionner le tableau de bord Cloud Monitoring | `bool` | `true` | Non |
| `dashboard_display_name` | Titre du tableau de bord Cloud Monitoring | `string` | `"🤖 AI Foundation..."` | Non |

## 📤 Sorties (Outputs)

| Nom | Description |
| :--- | :--- |
| `log_sink_name` | Nom de la ressource Sink Cloud Logging |
| `log_sink_writer_identity` | Identité de service (SA) du sink d'exportation |
| `log_dataset_id` | Identifiant du dataset BigQuery contenant les tables de logs |
| `dashboard_id` | Identifiant du tableau de bord Cloud Monitoring |

## 💡 Exemple d'Utilisation

```hcl
module "observability" {
  source = "./modules/observability"

  project_id          = "mon-projet-gcp"
  region              = "europe-west1"
  alert_email_address = "equipe-sre@example.com"
  enable_dashboard    = true
}
```
