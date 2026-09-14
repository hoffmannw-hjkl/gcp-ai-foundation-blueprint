# Module FinOps & Budget Alerts (`modules/finops-budget`)

Ce module provisionne une alerte de budget Cloud Billing (**Cloud Billing Budget**) spécifiquement circonscrite au projet de démo d'Intelligence Artificielle. Il prévient les dépassements de coûts imprévus lors des sessions de POCs, hackathons ou démonstrations client (Elevate & Spark).

## 🌟 Fonctionnalités

- **Filtrage Ciblé par Projet** :
  - Le budget s'applique uniquement au `project_id` concerné (`budget_filter.projects`), sans affecter les autres projets rattachés au compte de facturation (Billing Account).
- **Seuils d'Alerte Multiples** :
  - Alertes sur les dépenses réelles cumulées : 50%, 75%, 90% et 100%.
  - Alerte prédictive sur projection (**Forecasted Spend**) : Déclenche un avertissement dès que l'algorithme Google Cloud anticipe un dépassement de 100% avant la fin du mois calendaire en cours.
- **Canaux de Notification Flexibles** :
  - Canaux de notification par email via Cloud Monitoring.
  - Optionnel : Topic Cloud Pub/Sub pour déclencher un arrêt d'urgence automatisé (Cloud Function désactivant les clusters ou quotas).

## 📥 Entrées (Inputs)

| Nom | Description | Type | Défaut | Requis |
| :--- | :--- | :--- | :--- | :---: |
| `billing_account_id` | ID du compte de facturation Cloud Billing (ex: `012345-678901-ABCDEF`) | `string` | - | **Oui** |
| `project_id` | ID du projet Google Cloud cible | `string` | - | **Oui** |
| `display_name` | Nom d'affichage de l'alerte budgétaire | `string` | `"ai-foundation-monthly-budget"` | Non |
| `budget_amount` | Montant limite mensuel du budget (ex: 100 pour 100$) | `number` | `100` | Non |
| `currency_code` | Code devise du budget (ex: `USD`, `EUR`) | `string` | `"USD"` | Non |
| `threshold_percent_list` | Liste des pourcentages de dépenses réelles déclenchant une alerte | `list(number)` | `[0.5, 0.75, 0.9, 1.0]` | Non |
| `enable_forecasted_threshold` | Alerte prédictive si le coût prévisionnel dépasse 100% | `bool` | `true` | Non |
| `alert_emails` | Liste des adresses emails à notifier | `list(string)` | `[]` | Non |
| `pubsub_topic_id` | ID du topic Pub/Sub optionnel pour automatisation | `string` | `""` | Non |

## 📤 Sorties (Outputs)

| Nom | Description |
| :--- | :--- |
| `budget_id` | Identifiant de la ressource Budget Cloud Billing |
| `budget_display_name` | Nom affiché du budget |

## 💡 Exemple d'Utilisation

```hcl
module "finops_budget" {
  source = "./modules/finops-budget"

  billing_account_id = "012345-678901-ABCDEF"
  project_id         = "mon-projet-ai-demo"
  budget_amount      = 100
  currency_code      = "USD"
  alert_emails       = ["mon-equipe-ai@example.com"]
}
```
