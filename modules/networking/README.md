# Module Networking (`modules/networking`)

Ce module provisionne la colonne vertébrale réseau de la zone d'atterrissage (Landing Zone) pour les architectures IA sur Google Cloud. Il est conçu pour respecter strictement les contraintes de sécurité d'entreprise et les politiques d'organisation **Argolis** (interdiction d'adresses IP externes directes).

## 🌟 Fonctionnalités

- **VPC Custom Mode** : Réseau privé isolé en mode régional.
- **Sous-réseau Principal & Plages Secondaires** :
  - Plage primaire pour les nœuds de calcul, machines virtuelles et connecteurs VPC Serverless (`10.10.0.0/20`).
  - Plage secondaire dédiée aux Pods Kubernetes (`10.20.0.0/16` par défaut, soit 65 536 adresses).
  - Plage secondaire dédiée aux Services Kubernetes (`10.30.0.0/20` par défaut, soit 4 096 adresses).
- **Private Google Access** : Permet aux ressources sans IP publique d'interroger les APIs Google Cloud (Vertex AI, BigQuery, Cloud Storage) via les adresses IP privées virtuelles de Google.
- **Passerelle Cloud Router & Cloud NAT** : Egress Internet entièrement managé et sécurisé avec allocation automatique d'IPs de sortie pour le téléchargement de dépendances (GitHub, HuggingFace, pip, etc.).
- **Private Service Access (PSA)** : Réservation d'un bloc CIDR interne (`/16`) et peering direct avec `servicenetworking.googleapis.com` pour la connectivité privée vers Cloud SQL, Memorystore ou les Vertex AI Private Endpoints.
- **Règles de Pare-feu Zero Trust** :
  - Ingress IAP (`35.235.240.0/20`) pour SSH et administration sans exposition sur Internet.
  - Ingress pour les Health Checks des Load Balancers Google Cloud (`35.191.0.0/16`, `130.211.0.0/22`).
  - Communication interne au sein du VPC.

## 📥 Entrées (Inputs)

| Nom | Description | Type | Défaut | Requis |
| :--- | :--- | :--- | :--- | :---: |
| `project_id` | ID du projet Google Cloud cible | `string` | - | **Oui** |
| `region` | Région GCP pour le sous-réseau et Cloud NAT | `string` | `"europe-west1"` | Non |
| `network_name` | Nom du réseau VPC | `string` | `"ai-foundation-vpc"` | Non |
| `subnet_name` | Nom du sous-réseau principal | `string` | `"ai-foundation-subnet"` | Non |
| `subnet_cidr` | Plage CIDR primaire pour les nœuds/VMs | `string` | `"10.10.0.0/20"` | Non |
| `pods_cidr_name` | Nom de la plage secondaire pour les Pods GKE | `string` | `"gke-pods"` | Non |
| `pods_cidr` | Plage CIDR secondaire pour les Pods GKE | `string` | `"10.20.0.0/16"` | Non |
| `services_cidr_name` | Nom de la plage secondaire pour les Services GKE | `string` | `"gke-services"` | Non |
| `services_cidr` | Plage CIDR secondaire pour les Services GKE | `string` | `"10.30.0.0/20"` | Non |
| `enable_flow_logs` | Activer les VPC Flow Logs pour l'audit de sécurité | `bool` | `true` | Non |
| `enable_private_service_access` | Allouer et appairer la plage Private Service Access | `bool` | `true` | Non |
| `psa_prefix_length` | Longueur du masque de sous-réseau pour PSA | `number` | `16` | Non |

## 📤 Sorties (Outputs)

| Nom | Description |
| :--- | :--- |
| `network_id` | Identifiant du réseau VPC |
| `network_name` | Nom du réseau VPC |
| `network_self_link` | URI self_link du réseau VPC |
| `subnet_id` | Identifiant du sous-réseau primaire |
| `subnet_name` | Nom du sous-réseau primaire |
| `subnet_self_link` | URI self_link du sous-réseau primaire |
| `subnet_cidr` | Plage CIDR primaire |
| `pods_secondary_range_name` | Nom de la plage secondaire des Pods GKE |
| `services_secondary_range_name` | Nom de la plage secondaire des Services GKE |
| `router_name` | Nom du Cloud Router |
| `nat_name` | Nom de la passerelle Cloud NAT |

## 💡 Exemple d'Utilisation

```hcl
module "networking" {
  source = "./modules/networking"

  project_id                    = "mon-projet-gcp"
  region                        = "europe-west1"
  network_name                  = "ai-demo-vpc"
  subnet_name                   = "ai-demo-subnet"
  enable_private_service_access = true
}
```
