---
name: terraform-blueprint-validation
description: >-
  Automated runbook to format, validate, audit, and check zero-drift status on gcp-ai-foundation-blueprint.
  Use this skill whenever modifying Terraform modules, variables, or outputs.
---

# Terraform Blueprint Validation & Zero-Drift Runbook

Follow this sequential workflow whenever making changes to `.tf` files in `gcp-ai-foundation-blueprint`.

## Step 1: Recursive Formatting & Static Validation

Run `terraform fmt` and `terraform validate` using the local Terraform binary:

```bash
export PATH="$PATH:$HOME/bin:/usr/local/bin"
terraform fmt -recursive
terraform init -backend=false
terraform validate
```

## Step 2: Live Infrastructure Zero-Drift Check (When Connected to GCP)

When verifying against the active deployment (`wh-ai-blueprint-a363`), inject the active `gcloud` OAuth token to avoid Cloudtop ADC permission mismatches:

```bash
GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token) terraform plan -no-color
```

Verify that the plan outputs `No changes. Your infrastructure matches the configuration.` (or only the expected diff).

## Step 3: Documentation Synchronization

Whenever adding or modifying a root variable in `variables.tf` or an output in `outputs.tf`, update the corresponding reference tables in:
- `README.md` (French)
- `README-EN.md` (English)
- `terraform.tfvars.example`
