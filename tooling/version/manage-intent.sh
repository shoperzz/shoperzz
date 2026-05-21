#!/bin/bash
# ── Shoperzz Release Intent Manager ─────────────────────────────────────────
# This script pilots Changesets to create release intents.

set -e

# Colors
NC='\033[0m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'

header() {
  echo -e "\n${CYAN}🚀 Shoperzz — Intent Manager${NC}"
  echo -e "${CYAN}────────────────────────────────────────${NC}"
}

# Check for existing changesets to offer a reset
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

# 1. Main menu
header
echo -e "What is the intent of this change?"
echo -e "  [1] ${GREEN}Prerelease${NC} (Alpha, Beta, RC)"
echo -e "  [2] ${GREEN}Patch${NC}      (Bugs, minor fixes)"
echo -e "  [3] ${GREEN}Minor${NC}      (New features)"
echo -e "  [4] ${GREEN}Major${NC}      (Breaking changes, big features)"
echo -e "  [q] Quit"

read -p "Your choice: " INTENT

case $INTENT in
  1)
    echo -e "\nPrerelease type:"
    echo -e "  [a] alpha"
    echo -e "  [b] beta"
    echo -e "  [r] rc"
    read -p "Choice: " PRE_TYPE
    TAG="alpha"
    [[ "$PRE_TYPE" == "b" ]] && TAG="beta"
    [[ "$PRE_TYPE" == "r" ]] && TAG="rc"

    if [ -f ".changeset/pre.json" ]; then
      info "Project is already in PRE mode. Skipping initiation..."
    else
      info "Entering PRE mode (${TAG})..."
      pnpm changeset pre enter $TAG
    fi
    
    info "Creating changeset..."
    pnpm changeset add
    ;;
  2)
    pnpm changeset add --patch
    ;;
  3)
    pnpm changeset add --minor
    ;;
  4)
    pnpm changeset add --major
    ;;
  q|*)
    echo "Operation cancelled."
    exit 0
    ;;
esac

echo -e "\n${GREEN}✓  Intent recorded successfully.${NC}"
