#!/bin/bash
# ── Shoperzz Sovereign Intent Manager v3.0 ──────────────────────────────────
# This script pilots Changesets tracks and automated release intents.

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
  echo -e "\n${CYAN}🚀 Shoperzz — Sovereign Intent Manager v3.0${NC}"
  echo -e "${CYAN}───────────────────────────────────────────${NC}"
}

# Detection of current track
CURRENT_TRACK="Stable"
[[ -f ".changeset/pre.json" ]] && CURRENT_TRACK=$(node -p "require('./.changeset/pre.json').tag" 2>/dev/null || echo "Prerelease")

# 0. Sync/Purge Logic
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

# 1. Main Pilot Console
header
info "Current Track: [${YELLOW}${CURRENT_TRACK^^}${NC}]"
echo -e "\nWhat would you like to do?"

if [[ "$CURRENT_TRACK" == "Stable" ]]; then
  echo -e "  [1] ${GREEN}Enter Prerelease${NC} (Start Alpha/Beta/RC track)"
  echo -e "  [i] ${GREEN}Create Intent${NC}    (Patch/Minor/Major)"
else
  echo -e "  [i] ${GREEN}Create Intent${NC}    (Add changes to current ${CURRENT_TRACK} track)"
  echo -e "  [s] ${YELLOW}Switch Track${NC}     (e.g. Alpha -> Beta)"
  echo -e "  [x] ${RED}Exit to Stable${NC}   (Stop prereleases, go production)"
fi
echo -e "  [q] Quit"

read -p "Your choice: " CHOICE

case $CHOICE in
  1)
    echo -e "\nSelect Prerelease type:"
    echo -e "  [a] alpha"
    echo -e "  [b] beta"
    echo -e "  [r] rc"
    read -p "Choice: " PRE_TYPE
    TAG="alpha"; [[ "$PRE_TYPE" == "b" ]] && TAG="beta"; [[ "$PRE_TYPE" == "r" ]] && TAG="rc"
    
    info "Entering PRE mode ($TAG)..."
    pnpm changeset pre enter "$TAG"
    git add .changeset/pre.json
    git commit -m "chore(release): enter $TAG track"
    success "Track initiated."
    ;;
  i)
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
  s)
    [[ "$CURRENT_TRACK" == "Stable" ]] && error "You are already in Stable mode. Use [1] to enter prerelease."
    echo -e "\nNew target track:"
    echo -e "  [a] alpha"
    echo -e "  [b] beta"
    echo -e "  [r] rc"
    read -p "Choice: " NEW_TYPE
    NEW_TAG="alpha"; [[ "$NEW_TYPE" == "b" ]] && NEW_TAG="beta"; [[ "$NEW_TYPE" == "r" ]] && NEW_TAG="rc"
    
    info "Switching track $CURRENT_TRACK -> $NEW_TAG..."
    pnpm changeset pre exit
    pnpm changeset pre enter "$NEW_TAG"
    git add .changeset/pre.json
    git commit -m "chore(release): switch from $CURRENT_TRACK to $NEW_TAG track"
    success "Track successfully switched to $NEW_TAG."
    ;;
  x)
    [[ "$CURRENT_TRACK" == "Stable" ]] && error "You are already in Stable mode."
    warn "This will stop all future prereleases for this cycle."
    read -p "Are you sure you want to go STABLE? (y/N): " CONFIRM
    if [[ "$CONFIRM" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      info "Exiting pre-release mode..."
      pnpm changeset pre exit
      git add .changeset/pre.json || true
      git commit -m "chore(release): exit prerelease mode, return to stable track" || true
      success "Returned to STABLE track."
    fi
    ;;
  q|*)
    echo "Operation cancelled."
    exit 0
    ;;
esac

success "Operations completed successfully."
