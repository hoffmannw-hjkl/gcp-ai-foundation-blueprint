#!/usr/bin/env bash
# ==============================================================================
# scripts/sync-gtm.sh
# 
# Synchronise les commits locaux vers le dépôt officiel cloud-gtm/gcp-ai-foundation-blueprint
# via une Pull Request auto-approuvée / auto-mergée par lot de 5 commits.
# ==============================================================================

set -euo pipefail

TARGET_REPO="cloud-gtm/gcp-ai-foundation-blueprint"
TARGET_BRANCH="main"
DEFAULT_THRESHOLD=5
FORCE=false

for arg in "$@"; do
  case "$arg" in
    -f|--force)
      FORCE=true
      ;;
    -h|--help)
      echo "Usage: $0 [-f|--force]"
      echo "  -f, --force    Synchronise immédiatement sans attendre le seuil de $DEFAULT_THRESHOLD commits"
      exit 0
      ;;
  esac
done

if ! command -v gh &>/dev/null; then
  echo "❌ Erreur: 'gh' (GitHub CLI) n'est pas installé ou introuvable dans le PATH."
  exit 1
fi

if ! git remote | grep -q "^gtm$"; then
  echo "ℹ️ Le remote 'gtm' n'est pas encore configuré."
  echo "   Dès validation de la demande go/gtm-github-request, configurez-le avec :"
  echo "   git remote add gtm https://github.com/$TARGET_REPO.git"
  exit 0
fi

echo "🔍 Vérification de l'état de synchronisation avec $TARGET_REPO..."
git fetch gtm "$TARGET_BRANCH" --quiet 2>/dev/null || {
  echo "⚠️ Impossible de contacter le remote 'gtm'. Vérifiez vos droits d'accès ou que le dépôt a bien été créé."
  exit 1
}

PENDING_COUNT=$(git rev-list --count "gtm/$TARGET_BRANCH..HEAD")

if [ "$PENDING_COUNT" -eq 0 ]; then
  echo "✅ Aucun commit en attente. Votre branche locale est déjà synchronisée avec $TARGET_REPO ($TARGET_BRANCH)."
  exit 0
fi

echo "📊 Commits locaux en attente de synchronisation vers GTM : $PENDING_COUNT (seuil : $DEFAULT_THRESHOLD)"

if [ "$PENDING_COUNT" -lt "$DEFAULT_THRESHOLD" ] && [ "$FORCE" = false ]; then
  echo "ℹ️ Le seuil de $DEFAULT_THRESHOLD commits n'est pas encore atteint ($PENDING_COUNT/$DEFAULT_THRESHOLD)."
  echo "   Les commits restent enregistrés localement et sur votre repo GitHub personnel."
  echo "   Pour forcer la synchronisation immédiate vers GTM, lancez : $0 --force"
  exit 0
fi

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BRANCH_NAME="sync/batch-${TIMESTAMP}"
LATEST_SUBJECT=$(git log -1 --format="%s")

if [ "$PENDING_COUNT" -eq 1 ]; then
  PR_TITLE="$LATEST_SUBJECT"
else
  PR_TITLE="sync: batch sync of $PENDING_COUNT commits (${LATEST_SUBJECT})"
fi

PR_BODY="## Synchronisation automatique des commits par lot ($PENDING_COUNT commits)

### Liste des commits inclus :
$(git log --format="- %h %s (%an)" "gtm/$TARGET_BRANCH..HEAD")

---
*Généré et fusionné automatiquement via \`scripts/sync-gtm.sh\`.*"

echo "🚀 Préparation de la synchronisation vers $TARGET_REPO..."
echo "   Branche temporaire : $BRANCH_NAME"
echo "   Titre de la PR      : $PR_TITLE"

git push gtm "HEAD:refs/heads/$BRANCH_NAME" --quiet

PR_URL=$(gh pr create \
  --repo "$TARGET_REPO" \
  --base "$TARGET_BRANCH" \
  --head "$BRANCH_NAME" \
  --title "$PR_TITLE" \
  --body "$PR_BODY")

echo "🔗 PR créée : $PR_URL"

echo "⚡ Auto-fusion (merge) de la PR..."
gh pr merge "$PR_URL" --repo "$TARGET_REPO" --merge --delete-branch

echo "🔄 Synchronisation locale et mise à jour de github/main..."
git fetch gtm "$TARGET_BRANCH" --quiet
if [ "$(git rev-parse --abbrev-ref HEAD)" = "$TARGET_BRANCH" ]; then
  git merge --ff-only "gtm/$TARGET_BRANCH" --quiet
fi

if git remote | grep -q "^github$"; then
  git push github "$TARGET_BRANCH" --quiet 2>/dev/null || true
fi

echo "🎉 Synchronisation réussie ! $PENDING_COUNT commit(s) intégrés à $TARGET_REPO/$TARGET_BRANCH."
