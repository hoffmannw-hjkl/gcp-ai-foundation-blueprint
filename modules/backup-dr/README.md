# Module: Backup & Disaster Recovery (Backup and DR Service) 🛡️

Ce module implémente la résilience d'infrastructure et la protection de l'état applicatif selon les recommandations **Google Cloud Well-Architected Reliability Pillar** et le pattern éprouvé de **CivicLens** :

1. **Vaults Immuables (WORM Lock - Write Once Read Many)** :
   - **Vault Opérationnel Quotidien** : verrouillage de rétention minimale (ex: 7 jours) dans la région primaire (`europe-west1`).
   - **Vault Géo-Redondant (DR)** : rétention cross-région (ex: 4 semaines) dans la région de repli (`europe-west4`), immunisant les sauvegardes contre les corruptions logiques et ransomwares.
2. **Sauvegarde de l'État Applicatif (Backup for GKE)** :
   - Planification automatisée (`0 2 * * *`) pour sauvegarder :
     - Les manifests Kubernetes applicatifs (Deployments, Services, Ingress, ConfigMaps).
     - Les Secrets d'application.
     - Les volumes persistants (Persistent Volume Claims / Persistent Disks CSI) contenant les caches ou bases de données locales.

---

## 💻 Exemple d'Utilisation

```hcl
module "backup_dr" {
  source = "./modules/backup-dr"

  project_id                 = var.project_id
  region                     = "europe-west1"
  dr_region                  = "europe-west4"
  vault_prefix               = "ai-demo"
  daily_retention_days       = 7
  weekly_retention_weeks     = 4
  enable_geo_vault           = true
  enable_gke_workload_backup = true
  gke_cluster_id             = module.gke[0].cluster_id
}
```
