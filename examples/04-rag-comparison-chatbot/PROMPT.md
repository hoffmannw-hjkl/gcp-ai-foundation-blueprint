# Prompt de Développement — Chatbot RAG Démo GCP 🤖🏛️

## 1. Contexte & Objectif Avant-Vente
Application de démonstration pour un client externe (avant-vente Google Cloud / Programme Elevate & Spark), destinée à illustrer concrètement **l'apport du RAG (Retrieval-Augmented Generation) et du Grounding face à une recherche classique par mots-clés**. 
L'application est conçue pour être déployée en quelques minutes sur le **GCP AI Foundation Blueprint** (Cloud Run ou GKE Autopilot) avec un rendu visuel premium, fluide et ultra-démonstratif.

---

## 2. Architecture & Choix Techniques

- **Backend** : **Go** (binaire statique haute performance, démarrage instantané sur Cloud Run, zéro dépendance lourde, < 25 Mo).
- **APIs Google Cloud** :
  - **Vertex AI Gemini** (`gemini-2.5-flash` / `gemini-3.6-flash`) pour la synthèse groundée et le streaming.
  - **Vertex AI Discovery Engine / Agent Builder** (Data Store) ou **Cloud Storage + Search API** pour l'ingestion documentaire et la recherche vectorielle/sémantique.
- **Protocole Streaming** : **Server-Sent Events (SSE)** (`text/event-stream`) pour retransmettre en direct :
  1. `event: status` (indication des étapes : recherche, analyse des extraits, synthèse).
  2. `event: retrieval` (les chunks et passages documentaires identifiés).
  3. `event: token` (les tokens générés au fil de l'eau par Gemini).
  4. `event: done` (métadonnées finales et sources citées).
- **Frontend** : Interface moderne, réactive, épurée, intégrée et servie directement par le binaire Go (`//go:embed web/static/*`) sans dépendance complexe au runtime.
- **Sécurité & IAM** : **Zero-Trust & Workload Identity** (aucune clé de compte de service JSON statique requise).

---

## 3. Fonctionnalités Démos Attendues

### A. Effet Démonstratif Majeur : Toggle "Recherche Classique vs RAG Synthétisé"
Sur la même question de l'utilisateur :
- **Mode Recherche Classique** : Affiche les 3-5 extraits bruts pertinents avec score de pertinence, sans analyse ni reformulation (l'utilisateur doit tout lire et chercher lui-même).
- **Mode RAG GenAI** : Affiche la réponse synthétisée, formulée précisément, avec citations interactives surlignées renvoyant aux documents sources.
- **Bouton Toggle ou Vue Split-Screen** pour comparer côte à côte en un clic.

### B. Gestion Dynamique du Corpus Documentaire
- **Panneau latéral** dédié à la documentation :
  - Dépôt de fichiers (PDF, TXT, Markdown, DOCX) vers le bucket Cloud Storage (`rag_bucket_url`).
  - Ajout d'URLs web à analyser.
  - Statut des documents : `Prêt (Indexé)` vs `Indexation en cours (GCP)`.
  - Jeu de documents d'exemples pré-chargés pour les démonstrations immédiates.

### C. Transparence du Processus de "Thinking / Retrieval"
- Indicateur visuel élégant affichant l'étape de recherche avant l'apparition de la synthèse :
  > *"Consultation de 4 passages documentaires dans le corpus technique..."*

### D. Design & Expérience Utilisateur
- Palette sobre (thème sombre/clair automatique, design Google Cloud).
- Accents visuels soignés sur les badges de sources et le curseur de streaming.
- Responsive et optimisé pour projection sur grand écran en salle de réunion.
