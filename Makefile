.PHONY: help verify fmt validate plan demo-light demo-enterprise sync-gtm

PROJECT_ID ?= wh-ai-blueprint-a363
REGION     ?= europe-west1

help: ## Affiche l'aide interactive des commandes de démo et de vérification
	@echo "================================================================================"
	@echo " 🏗️  GCP AI Foundation Blueprint — Commandes de Démonstration & Gatekeeper"
	@echo "================================================================================"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

verify: ## Exécute le Gatekeeper M1L1 (terraform fmt, validate & audit sécurité IAM/WORM)
	@./.agents/skills/terraform-blueprint-validation/scripts/verify.sh

fmt: ## Formate récursivement tous les modules Terraform (HCL canonique)
	@terraform fmt -recursive

validate: ## Initialise (sans backend) et valide la syntaxe des 9 modules Terraform
	@terraform init -backend=false && terraform validate

demo-light: ## Simule un déploiement Profil Lightweight Serverless (Cloud Run + GCS + BQ + Vertex AI)
	@terraform plan -var="project_id=$(PROJECT_ID)" -var="region=$(REGION)" \
		-var="enable_gke=false" -var="enable_bastion=false" -var="enable_waf=false" -var="enable_backup_dr=false"

demo-enterprise: ## Simule un déploiement Profil Full Enterprise Production (GKE Autopilot + WAF + CMEK + WORM)
	@terraform plan -var="project_id=$(PROJECT_ID)" -var="region=$(REGION)" \
		-var="enable_gke=true" -var="enable_cloudrun=true" -var="enable_waf=true" -var="enable_backup_dr=true" -var="enable_cmek=true"

sync-gtm: ## Synchronise la branche courante vers cloud-gtm/gcp-ai-foundation-blueprint via Pull Request
	@./scripts/sync-gtm.sh --force
