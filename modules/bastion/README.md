# Module Bastion Host (`modules/bastion`)

Ce module déploie une machine virtuelle d'administration privée (**Bastion / Jumpbox**) sous Debian 12, conçue pour opérer les clusters GKE privés et interroger les services internes sans jamais exposer d'adresse IP publique sur Internet (conformité stricte aux règles Argolis).

## 🌟 Fonctionnalités

- **Zéro IP Publique (Argolis Ready)** :
  - La machine virtuelle ne possède aucun bloc `access_config`. Elle est raccordée uniquement à l'interface privée du sous-réseau.
- **Accès Sécurisé Identity-Aware Proxy (IAP)** :
  - Toutes les sessions SSH et les tunnels TCP sont encapsulés et authentifiés via l'infrastructure Google IAP (`35.235.240.0/20`).
- **OS Login Enforcé** :
  - `enable-oslogin = TRUE` : Authentification centralisée basée sur les identités IAM de Google Cloud (pas de clés SSH statiques dans les métadonnées).
- **Outillage DevOps & IA Préinstallé** :
  - Script d'amorçage automatique (startup-script) installant :
    - `kubectl` et `google-cloud-cli-gke-gcloud-auth-plugin`
    - `tinyproxy` (forward proxy configuré sur le port 8888 pour relayer des requêtes vers le master GKE ou les APIs internes)
    - `git`, `jq`, `curl`
- **Compte de Service Moindre Privilège** :
  - Permissions limitées à l'écriture de logs/métriques, à l'administration GKE (`roles/container.developer`) et à l'interrogation de Vertex AI (`roles/aiplatform.user`).

## 📥 Entrées (Inputs)

| Nom | Description | Type | Défaut | Requis |
| :--- | :--- | :--- | :--- | :---: |
| `project_id` | ID du projet Google Cloud cible | `string` | - | **Oui** |
| `zone` | Zone GCP pour héberger la VM (ex: europe-west1-b) | `string` | `"europe-west1-b"` | Non |
| `bastion_name` | Nom de l'instance Compute Engine | `string` | `"ai-foundation-bastion"` | Non |
| `subnet_id` | ID ou self_link du sous-réseau où attacher la VM | `string` | - | **Oui** |
| `machine_type` | Type de machine Compute Engine | `string` | `"e2-small"` | Non |
| `enable_tinyproxy` | Activer et configurer le proxy tinyproxy (port 8888) | `bool` | `true` | Non |
| `extra_tags` | Tags réseau additionnels pour le pare-feu | `list(string)` | `[]` | Non |

## 📤 Sorties (Outputs)

| Nom | Description |
| :--- | :--- |
| `instance_id` | Identifiant de l'instance Bastion |
| `instance_name` | Nom de l'instance Bastion |
| `private_ip` | Adresse IPv4 interne de la VM |
| `service_account_email` | Email du compte de service de la VM |
| `ssh_iap_command` | Commande `gcloud` prête à copier-coller pour se connecter en SSH via IAP |

## 💡 Connexion au Bastion

Pour vous connecter au bastion privé depuis votre poste de travail :

```bash
gcloud compute ssh ai-foundation-bastion \
  --zone europe-west1-b \
  --project MON_PROJECT_ID \
  --tunnel-through-iap
```

Pour créer un tunnel proxy HTTP vers le VPC local via Tinyproxy :

```bash
gcloud compute start-iap-tunnel ai-foundation-bastion 8888 \
  --local-host-port=localhost:8888 \
  --zone europe-west1-b
```
