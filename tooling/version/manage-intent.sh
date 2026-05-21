#!/bin/bash
# ── Shoperzz Sovereign Intent Manager v4.0 (Logical Guard) ──────────────────
# This script ensures rigorous governance by preventing track regressions.

set -e

# Colors
NC='\033[0m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'

info() { echo -e "${BLUE}ℹ  $1${NC}"; }
warn() { echo -e "${YELLOW}⚠  $1${NC}"; }
error() { echo -e "${RED}✖  $1${NC}"; exit 1; }
success() { echo -e "${GREEN}✓  $1${NC}"; }

header() {
  echo -e "\n${CYAN}🚀 Shoperzz — Sovereign Intent Manager v4.0${NC}"
  echo -e "${CYAN}───────────────────────────────────────────${NC}"
}

# 1. Detection of local track ranking
get_rank() {
  case $1 in
    "alpha") echo 1 ;;
    "beta") echo 2 ;;
    "rc") echo 3 ;;
    "Stable") echo 0 ;;
    *) echo 0 ;;
  esac
}

CURRENT_TAG="Stable"
[[ -f ".changeset/pre.json" ]] && CURRENT_TAG=$(node -p "require('./.changeset/pre.json').tag" 2>/dev/null || echo "Prerelease")
CURRENT_RANK=$(get_rank "$CURRENT_TAG")

# 2. Remote check (NPM tags)
REMOTE_TRACK="Stable"
info "Verifying remote track on NPM..."
NPM_TAGS=$(pnpm dist-tag ls @shoperzz/core 2>/dev/null || echo "")

if [[ "$NPM_TAGS" == *"alpha"* ]]; then REMOTE_TRACK="alpha"; fi
if [[ "$NPM_TAGS" == *"beta"* ]]; then REMOTE_TRACK="beta"; fi
if [[ "$NPM_TAGS" == *"rc"* ]]; then REMOTE_TRACK="rc"; fi

REMOTE_RANK=$(get_rank "$REMOTE_TRACK")

# Logical Guard: Enforce remote truth if local is lagging
if [ "$REMOTE_RANK" -gt "$CURRENT_RANK" ]; then
    warn "REMOTE CONFLICT: NPM is already on [${REMOTE_TRACK^^}] track while you are on [${CURRENT_TAG^^}]."
    warn "Regressing to a lower track is prohibited by Shoperzz Governance."
    read -p "Would you like to auto-align to [${REMOTE_TRACK^^}] now? (Y/n) " ALIGN
    if [[ "$ALIGN" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        pnpm changeset pre exit || true
        pnpm changeset pre enter "$REMOTE_TRACK"
        git add .changeset/pre.json
        git commit -m "chore(release): align with remote ${REMOTE_TRACK} track"
        success "Aligned with remote track. Please restart 'pnpm push'."
        exit 0
    fi
fi

# 3. Intent & Purge check
EXISTING_CHANGESETS=$(find .changeset -name "*.md" ! -name "README.md" 2>/dev/null | wc -l)
if [ "$EXISTING_CHANGESETS" -gt 0 ]; then
  header
  warn "Existing release intents found ($EXISTING_CHANGESETS file(s))."
  echo -e "What would you like to do?"
  echo -e "  [c] ${GREEN}Continue${NC} (Add to existing intents)"
  echo -e "  [r] ${YELLOW}Reset${NC}    (Purge everything and start fresh)"
  echo -e "  [q] Quit"
  read -p "Choice: " ACTION
  if [ "$ACTION" == "r" ]; then
    info "Purging existing intents..."
    find .changeset -name "*.md" ! -name "README.md" -delete
    success "Intents purged."
  elif [ "$ACTION" == "q" ]; then
    exit 0
  fi
fi

# 4. Filtered Console
header
info "Current Focus: [${YELLOW}${CURRENT_TAG^^}${NC}] | Registry: [${CYAN}${REMOTE_TRACK^^}${NC}]"

echo -e "\nWhat is your next move?"
echo -e "  [i] ${GREEN}Create Intent${NC}    (Stay in ${CURRENT_TAG^^} - Increments 0, 1, 2...)"

# Switch Menu (Only superior tracks)
SWITCH_OPTS=0
if [[ "$CURRENT_RANK" -lt 1 ]]; then echo -e "  [a] ${YELLOW}Switch to Alpha${NC}"; SWITCH_OPTS=$((SWITCH_OPTS+1)); fi
if [[ "$CURRENT_RANK" -lt 2 ]]; then echo -e "  [b] ${YELLOW}Switch to Beta${NC}"; SWITCH_OPTS=$((SWITCH_OPTS+1)); fi
if [[ "$CURRENT_RANK" -lt 3 ]]; then echo -e "  [r] ${YELLOW}Switch to RC${NC}"; SWITCH_OPTS=$((SWITCH_OPTS+1)); fi

if [[ "$CURRENT_RANK" -gt 0 ]]; then
  echo -e "  [x] ${RED}Exit to Stable${NC} (Finalize release)"
fi
echo -e "  [q] Quit"

read -p "Your choice: " CHOICE

case $CHOICE in
  i)
    echo -e "\nIntent level for ${CURRENT_TAG^^}:"
    echo -e "\nIntent level:"
    echo -e "  [1] ${GREEN}Patch${NC} (Bugs)"
    echo -e "  [2] ${GREEN}Minor${NC} (Features)"
    echo -e "  [3] ${GREEN}Major${NC} (Breaking)"
    read -p "Choice: " LEVEL
    LEVEL_STR="patch"; [[ "$LEVEL" == "2" ]] && LEVEL_STR="minor"; [[ "$LEVEL" == "3" ]] && LEVEL_STR="major"
    warn "PACKAGE SELECTION: Use SPACE to toggle/select packages, then ENTER to confirm."
    info "Creating changeset..."
    pnpm changeset add --$LEVEL_STR
    ;;
  a|b|r)
    TAG="alpha"; [[ "$CHOICE" == "b" ]] && TAG="beta"; [[ "$CHOICE" == "r" ]] && TAG="rc"
    NEW_RANK=$(get_rank "$TAG")
    if [ "$NEW_RANK" -le "$CURRENT_RANK" ] && [ "$CURRENT_TAG" != "Stable" ]; then
        error "Illogical switch: Cannot move from ${CURRENT_TAG} to ${TAG}."
    fi
    info "Initiating track: ${TAG}..."
    [[ "$CURRENT_TAG" != "Stable" ]] && pnpm changeset pre exit
    pnpm changeset pre enter "$TAG"
    git add .changeset/pre.json
    git commit -m "chore(release): switch to ${TAG} track"
    success "Successfully moved to ${TAG} track."
    ;;
  x)
    [[ "$CURRENT_RANK" -eq 0 ]] && error "Already in Stable mode."
    warn "Going stable will close the current pre-release cycle."
    read -p "Are you sure? (y/N): " CONFIRM
    if [[ "$CONFIRM" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      pnpm changeset pre exit
      git add .changeset/pre.json || true
      git commit -m "chore(release): exit pre-release, return to stable" || true
      success "Returned to STABLE track."
    fi
    ;;
  q|*)
    echo "Operation cancelled."
    exit 0
    ;;
esac

success "Governance cycle completed."
