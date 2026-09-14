# 04 - Chatbot RAG Démo GCP (Comparateur Recherche Classique vs RAG) 🤖⚖️

> **Projet de démonstration avant-vente prêt à l'emploi**, conçu pour illustrer en clientèle l'apport immédiat du **RAG (Retrieval-Augmented Generation) et du Grounding avec Gemini** face à un moteur de recherche classique par mots-clés.

Ce projet met en pratique le [**Prompt de Développement**](PROMPT.md) et se déploie en 2 minutes sur le **GCP AI Foundation Blueprint** (GKE Autopilot ou Cloud Run).

---

## 🌟 Fonctionnalités Clés Démo

1. **Effet Avant / Après (Toggle & Split-Screen)** :
   - **Mode Recherche Classique** : Affiche les extraits bruts sans synthèse ni compréhension (obligeant l'utilisateur à tout lire).
   - **Mode RAG GenAI** : Génère une synthèse rédigée et sourcée avec citations interactives.
2. **Transparence du Grounding** :
   - L'interface affiche en temps réel les documents et passages consultés avant de streamer la réponse finale.
3. **Gestion Documentaire à la Volée** :
   - Panneau latéral avec statut d'indexation (`Prêt` vs `En cours`).
   - Modal d'ajout immédiat de nouveaux textes ou URLs dans le corpus.
4. **Architecture Ultra-Sobre & Rapide** :
   - Backend Go compilé en binaire statique unique.
   - Frontend intégré via `embed.FS` (zéro serveur Node.js séparé, démarrage en < 1 seconde sur Cloud Run).
   - Streaming temps réel par **Server-Sent Events (SSE)**.

---

## 🚀 Lancement Local

```bash
cd examples/04-rag-comparison-chatbot

# Exécuter en local avec vos identifiants GCP
export GCP_PROJECT=$(gcloud config get-value project)
export GCP_REGION="europe-west1"
export GEMINI_MODEL="gemini-2.5-flash"
export GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token)

go run main.go
# Accédez à http://localhost:8080
```

---

## ☁️ Déploiement sur Cloud Run

```bash
# 1. Build de l'image Docker sur Artifact Registry
gcloud builds submit --tag "europe-west1-docker.pkg.dev/${GCP_PROJECT}/ai-demo-repo/rag-chatbot:latest" .

# 2. Déploiement Serverless
gcloud run deploy rag-comparison-demo \
  --image "europe-west1-docker.pkg.dev/${GCP_PROJECT}/ai-demo-repo/rag-chatbot:latest" \
  --region europe-west1 \
  --platform managed \
  --allow-unauthenticated \
  --set-env-vars "GCP_PROJECT=${GCP_PROJECT},GCP_REGION=europe-west1,GEMINI_MODEL=gemini-2.5-flash"
```

---

## ☸️ Déploiement sur GKE Autopilot (via le Blueprint)

Utilisez les templates Kubernetes du dossier [`examples/03-sample-app-manifests/`](../03-sample-app-manifests/) en pointant l'image vers votre conteneur compilé. Le pod bénéficiera automatiquement de **Workload Identity** sans aucune clé JSON statique.
