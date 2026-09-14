# Module Security & WAF (`modules/security-waf`)

Ce module fournit une protection périmétrique d'entreprise complète au niveau de la couche applicative (Layer 7) en utilisant **Google Cloud Armor**, combinée avec la gestion d'adresses IP globales statiques, de certificats SSL managés par Google et l'attribution des droits d'accès Zero Trust via **Identity-Aware Proxy (IAP)**.

## 🌟 Fonctionnalités

- **Règles WAF Pré-configurées OWASP Top 10** :
  - `sqli-v33-stable` : Prévention des injections SQL.
  - `xss-v33-stable` : Prévention des attaques Cross-Site Scripting.
  - `lfi-v33-stable` : Protection contre l'inclusion de fichiers locaux (LFI).
  - `rfi-v33-stable` : Protection contre l'inclusion de fichiers distants (RFI).
  - `rce-v33-stable` : Blocage de l'exécution de code à distance.
  - `protocolattack-v33-stable` : Rejet des anomalies et violations de protocoles HTTP.
  - `scannerdetection-v33-stable` : Détection et blocage des scanners de vulnérabilités automatiques.
  - `sessionfixation-v33-stable` : Protection contre la fixation de session.
- **Limitation de Débit Adaptative (Rate Limiting)** :
  - Plafonne le nombre de requêtes autorisées par adresse IP client sur une fenêtre glissante (ex: 120 req/min).
  - En cas de dépassement, applique un blocage temporaire (`rate_based_ban` renvoyant un HTTP 429).
- **Protection Adaptative Cloud Armor (Adaptive Protection)** :
  - Détection des attaques DDoS applicatives de couche 7 par Machine Learning Google.
- **Mode Prévisualisation (Preview Mode)** :
  - Possibilité d'activer les règles en mode journalisation seule sans bloquer le trafic pour observer le comportement lors des phases de démonstration.
- **Gestionnaire SSL & IP** :
  - Réservation d'une adresse IPv4 globale externe pour l'Ingress.
  - Provisionnement d'un certificat SSL managé Google (renouvellement automatique).
- **Accès Sécurisé IAP** :
  - Attribution automatique du rôle `roles/iap.httpsResourceAccessor` pour l'authentification OAuth2 d'entreprise.

## 📥 Entrées (Inputs)

| Nom | Description | Type | Défaut | Requis |
| :--- | :--- | :--- | :--- | :---: |
| `project_id` | ID du projet Google Cloud cible | `string` | - | **Oui** |
| `policy_name` | Nom de la stratégie Cloud Armor | `string` | `"ai-foundation-waf-policy"` | Non |
| `enable_adaptive_protection` | Activer la protection ML Layer 7 | `bool` | `true` | Non |
| `enable_owasp_rules` | Activer le jeu de règles CRS OWASP Top 10 | `bool` | `true` | Non |
| `enable_rate_limiting` | Activer le rate limiting anti-DDoS / anti-bruteforce | `bool` | `true` | Non |
| `rate_limit_threshold_count` | Seuil maximal de requêtes par IP dans la fenêtre | `number` | `120` | Non |
| `rate_limit_interval_sec` | Fenêtre d'évaluation en secondes | `number` | `60` | Non |
| `rate_limit_ban_duration_sec` | Durée du bannissement temporaire en secondes | `number` | `300` | Non |
| `preview_mode` | Mode journalisation seule sans blocage | `bool` | `false` | Non |
| `allowed_ip_ranges` | Plages IP autorisées (Allowlist) | `list(string)` | `[]` | Non |
| `denied_ip_ranges` | Plages IP explicitement bloquées (Blocklist) | `list(string)` | `[]` | Non |
| `create_external_ip` | Réserver une IP globale externe statique | `bool` | `true` | Non |
| `ip_name` | Nom de l'IP externe réservée | `string` | `"ai-foundation-global-ip"` | Non |
| `domain_name` | Nom de domaine pour le certificat SSL managé | `string` | `""` | Non |
| `admin_email` | Email de l'administrateur pour l'accès IAP | `string` | `""` | Non |

## 📤 Sorties (Outputs)

| Nom | Description |
| :--- | :--- |
| `security_policy_id` | Identifiant de la politique de sécurité Cloud Armor |
| `security_policy_name` | Nom de la politique de sécurité Cloud Armor |
| `security_policy_self_link` | URI self_link de la politique Cloud Armor |
| `external_ip_address` | Adresse IPv4 externe globale réservée |
| `external_ip_name` | Nom de la ressource IP externe |
| `ssl_certificate_id` | Identifiant du certificat SSL managé Google |
| `ssl_certificate_name` | Nom de la ressource certificat SSL |

## 💡 Exemple d'Utilisation

```hcl
module "waf" {
  source = "./modules/security-waf"

  project_id                 = "mon-projet-gcp"
  policy_name                = "demo-ai-waf"
  enable_owasp_rules         = true
  enable_rate_limiting       = true
  rate_limit_threshold_count = 100
  domain_name                = "demo.altostrat.com"
  admin_email                = "ingenieur-ia@example.com"
}
```
