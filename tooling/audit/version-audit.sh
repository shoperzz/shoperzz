#!/bin/bash
# ── Audit de Cohérence de Version Shoperzz ──────────────────────────────────
# Ce script vérifie que le local et le distant sont synchronisés.

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Fonctions utilitaires
info() { echo -e "${BLUE}ℹ  $1${NC}"; }
success() { echo -e "${GREEN}✓  $1${NC}"; }
warn() { echo -e "${YELLOW}⚠  $1${NC}"; }
error() { echo -e "${RED}✖  $1${NC}"; }

# 1. Récupération de la version locale (Source: @shoperzz/core)
LOCAL_VERSION=$(node -p "require('./packages/core/package.json').version")
info "Version locale détectée (@shoperzz/core) : ${LOCAL_VERSION}"

# 2. Récupération des tags distants
info "Synchronisation des tags depuis GitHub..."
git fetch --tags origin > /dev/null 2>&1 || warn "Impossible de fetch les tags (vérifiez votre connexion ou SSH)."

# 3. Identification du dernier tag officiel (format vX.Y.Z*)
# On cherche le tag le plus élevé qui commence par 'v'
REMOTE_TAG=$(git tag -l "v*" --sort=-v:refname | head -n 1)

if [[ -z "$REMOTE_TAG" ]]; then
  success "Aucun tag distant trouvé. Premier déploiement ?"
  exit 0
fi

# Extraction de la version du tag (on enlève le 'v' initial)
REMOTE_VERSION="${REMOTE_TAG#v}"
info "Dernier tag détecté sur GitHub : ${REMOTE_TAG}"

# 4. Comparaison Logique (SemVer simple)
if [[ "$LOCAL_VERSION" == "$REMOTE_VERSION" ]]; then
  success "Cohérence parfaite : Local (${LOCAL_VERSION}) == Distant (${REMOTE_VERSION})"
  exit 0
fi

# Cas de conflit : Local < Distant
# Note: On utilise node pour une comparaison SemVer robuste
IS_BEHIND=$(node -p "require('semver').lt('$LOCAL_VERSION', '$REMOTE_VERSION') ? 'true' : 'false'" 2>/dev/null || echo "unknown")

if [[ "$IS_BEHIND" == "true" ]]; then
  error "CONFLIT DÉTECTÉ : Votre version locale ($LOCAL_VERSION) est INFÉRIEURE au tag distant ($REMOTE_VERSION)."
  warn "Cela arrive si un bot ou un autre collaborateur a déjà poussé une version supérieure."
  warn "Action recommandée : Faites un 'git pull' ou ajustez votre intention de version."
  exit 1
elif [[ "$IS_BEHIND" == "false" ]]; then
  success "Progression validée : Votre version ($LOCAL_VERSION) est supérieure au tag distant ($REMOTE_VERSION)."
  exit 0
else
  # Fallback si semver n'est pas installé globalement (on utilise une comparaison de string basique)
  warn "Comparaison SemVer simplifiée (npm 'semver' non détecté)..."
  if [[ "$LOCAL_VERSION" < "$REMOTE_VERSION" ]]; then
    error "Conflit probable : $LOCAL_VERSION < $REMOTE_VERSION"
    exit 1
  fi
fi
