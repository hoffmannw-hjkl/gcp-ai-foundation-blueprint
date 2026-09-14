# Architecture Deep-Dive & Guide de Référence 🏛️

Ce document décrit en profondeur les choix d'architecture, la matrice de conformité aux contraintes **Google Cloud Argolis**, ainsi que les stratégies d'optimisation des coûts (**FinOps**) intégrées au blueprint.

---

## 1. Matrice de Conformité Argolis

Dans les environnements de démonstration et d'avant-vente Google Cloud (Argolis), des règles de gouvernance organisationnelles strictes sont appliquées. Ce blueprint a été conçu pour satisfaire ces règles par défaut :

| Contrainte Organisationnelle | Règle Enforcée dans le Blueprint | Module Responsable |
| :--- | :--- | :--- |
| `constraints/compute.vmExternalIpAccess` | **Aucune adresse IP externe** sur les VMs Bastion, les nœuds GKE ou les connecteurs VPC. L'ensemble des calculs s'effectue dans des sous-réseaux privés. | `networking`, `bastion`, `compute-gke` |
| Sortie Internet Sécurisée | Déploiement systématique de **Cloud Router + Cloud NAT** pour permettre l'egress (pip, Docker Hub, HuggingFace, GitHub) sans IP publique. | `networking` |
| Administration & Sécurité Périmétrique | Accès administratif exclusivement via **Cloud IAP (Identity-Aware Proxy)** sur la plage `35.235.240.0/20` et activation obligatoire d'**OS Login**. | `networking`, `bastion` |
| Private Google Access | Activé sur tous les sous-réseaux pour que les appels vers Vertex AI, BigQuery et Cloud Storage transitent par les VIPs privées Google. | `networking` |
| Interconnexion de Services Managés | Réservation d'un bloc CIDR interne pour **Private Service Access (PSA)** via `servicenetworking.googleapis.com`. | `networking` |

---

## 2. Résilience de l'Observabilité & Dérive de Schéma

### Le Problème Historique (`table_invalid_schema`)
Lors de l'exportation des logs GKE vers BigQuery via un sink Cloud Logging, une dérive fréquente survient :
- Les conteneurs système Kubernetes (`kube-system`, `gke-gmp-system`, plugins CNI Fluentbit / Calico / Cilium) produisent des logs non structurés.
- En particulier, le champ `jsonPayload.address` est émis tantôt sous la forme d'une chaîne scalaire (ex: `"10.10.1.5"`), tantôt sous la forme d'un objet JSON complexe (`{"street": "...", "zip": "..."}`).
- Dès que BigQuery reçoit deux types incompatibles pour la même colonne, l'ingestion de la table échoue définitivement avec l'erreur :
  ```text
  Error Code: table_invalid_schema
  Error Detail: This field: address is not a record.
  ```

### La Solution Appliquée dans le Blueprint
Le module `observability` intègre un filtre d'exclusion éprouvé et automatisé :
```text
severity >= DEFAULT
AND NOT (jsonPayload.plugins.ipam.ranges:*)
AND NOT (resource.type="k8s_container" AND (resource.labels.namespace_name="kube-system" OR resource.labels.namespace_name="gke-gmp-system"))
AND NOT (jsonPayload.address:*)
```
De plus, l'option `use_partitioned_tables = true` est activée pour partitionner les tables BigQuery par date d'ingestion.

---

## 3. Stratégie d'Identité : Workload Identity & Moindre Privilège

L'utilisation de clés de compte de service JSON téléchargeables (`sa-key.json`) est un risque majeur de sécurité et est proscrite par les audits de conformité.

Ce blueprint applique **Workload Identity** :
1. Un compte de service Google (GSA) dédié est créé par module (`${cluster_name}-ai-sa` ou `${service_name}-sa`).
2. Les rôles IAM stricts sont accordés au GSA :
   - `roles/aiplatform.user` (interrogation des modèles Vertex AI / Gemini)
   - `roles/bigquery.dataEditor` & `roles/bigquery.jobUser` (requêtes et embeddings Lakehouse)
   - `roles/storage.objectViewer` (lecture des documents RAG)
   - `roles/logging.logWriter` & `roles/monitoring.metricWriter`
3. Le compte de service Kubernetes (KSA) est relié au GSA via :
   ```hcl
   member = "serviceAccount:${var.project_id}.svc.id.goog[${var.kubernetes_namespace}/${var.kubernetes_service_account}]"
   ```

---

## 4. Recommandations FinOps pour Démos & POCs

Pour maintenir les coûts d'infrastructure au minimum lors des démonstrations :
1. **Choisir Cloud Run pour les POCs rapides** : L'option `enable_cloudrun = true` et `enable_gke = false` permet un dimensionnement à zéro (`min_instances = 0`), ne générant aucun coût hors sollicitation.
2. **Cluster GKE Autopilot** : Lorsque GKE est requis (architectures microservices, agents multiples, orchestrateurs complexes), le mode Autopilot facture uniquement les ressources CPU/RAM réellement réservées par les Pods.
3. **Durée de vie des tables BigQuery** : Le paramètre `default_table_expiration_ms` peut être configuré à 7 jours ou 14 jours pour purger automatiquement les tables de test.
4. **Cycle de vie Cloud Storage** : Les artefacts IA et caches de modèles migrent automatiquement vers la classe **Nearline** après 30 jours.
