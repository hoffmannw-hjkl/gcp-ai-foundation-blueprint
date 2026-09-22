#!/usr/bin/env bash
set -euo pipefail

TERRAFORM="${TERRAFORM:-/usr/local/google/home/hoffmannw/bin/terraform}"

echo "🔍 [1/2] Formatting & Static Validation..."
"$TERRAFORM" fmt -recursive
"$TERRAFORM" init -backend=false >/dev/null
"$TERRAFORM" validate
echo "✅ Static validation passed."

if command -v gcloud >/dev/null 2>&1 && [ -f "terraform.tfstate" ]; then
  echo "🔍 [2/2] Checking live GCP infrastructure drift..."
  TOKEN=$(gcloud auth print-access-token 2>/dev/null || true)
  if [ -n "$TOKEN" ]; then
    GOOGLE_OAUTH_ACCESS_TOKEN="$TOKEN" "$TERRAFORM" plan -no-color | tail -n 10
  fi
fi
