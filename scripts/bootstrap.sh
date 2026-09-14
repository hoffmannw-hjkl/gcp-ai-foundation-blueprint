#!/usr/bin/env bash
# ==============================================================================
# scripts/bootstrap.sh
# 
# Bootstrap un projet GCP pour héberger la fondation d'infrastructure AI :
# - Active toutes les APIs requises (Compute, GKE, Vertex AI, BigQuery, etc.)
# - Crée le bucket de backend Terraform sécurisé (UBLA, versioning)
# - Affiche la configuration backend à inclure dans versions.tf
# ==============================================================================

set -euo pipefail

PROJECT_ID="${1:-$(gcloud config get-value project 2>/dev/null || true)}"
REGION="${2:-europe-west1}"

if [ -z "$PROJECT_ID" ]; then
  echo "❌ Erreur: PROJECT_ID introuvable. Spécifiez-le en argument :"
  echo "   Usage: $0 <PROJECT_ID> [REGION]"
  exit 1
fi

echo "🚀 Démarrage du bootstrap GCP AI Foundation sur le projet : $PROJECT_ID ($REGION)..."

# 1. Activation des APIs requises
echo "📦 1/2 Activation des APIs Google Cloud..."
gcloud services enable \
  compute.googleapis.com \
  container.googleapis.com \
  aiplatform.googleapis.com \
  bigquery.googleapis.com \
  storage.googleapis.com \
  logging.googleapis.com \
  monitoring.googleapis.com \
  iap.googleapis.com \
  servicenetworking.googleapis.com \
  vpcaccess.googleapis.com \
  run.googleapis.com \
  billingbudgets.googleapis.com \
  backupdr.googleapis.com \
  gkebackup.googleapis.com \
  cloudresourcemanager.googleapis.com \
  iam.googleapis.com \
  --project="$PROJECT_ID"

echo "✅ APIs activées avec succès."

# 2. Création du Bucket GCS pour l'état Terraform
STATE_BUCKET="${PROJECT_ID}-tfstate-ai-foundation"
echo "🪣 2/2 Vérification et création du bucket d'état Terraform : gs://${STATE_BUCKET}..."

if ! gcloud storage buckets describe "gs://${STATE_BUCKET}" --project="$PROJECT_ID" &>/dev/null; then
  gcloud storage buckets create "gs://${STATE_BUCKET}" \
    --project="$PROJECT_ID" \
    --location="$REGION" \
    --uniform-bucket-level-access \
    --default-storage-class=STANDARD
  
  # Activer le versioning pour l'historique et la sécurité du state
  gcloud storage buckets update "gs://${STATE_BUCKET}" --versioning
  echo "✅ Bucket gs://${STATE_BUCKET} créé avec Uniform Bucket-Level Access et Versioning."
else
  echo "ℹ️ Le bucket gs://${STATE_BUCKET} existe déjà."
fi

echo ""
echo "======================================================================"
echo "🎉 Bootstrap terminé ! Vous pouvez configurer votre backend Terraform :"
echo "======================================================================"
echo "Dans versions.tf (ou backend.tf) :"
echo "terraform {"
echo "  backend \"gcs\" {"
echo "    bucket = \"${STATE_BUCKET}\""
echo "    prefix = \"ai-foundation/state\""
echo "  }"
echo "}"
echo "======================================================================"
