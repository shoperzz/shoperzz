#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# push.sh — Secure and automated push script for Shoperzz monorepo
# Usage: ./tooling/push.sh [--no-verify] [--force]
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

# ── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Helpers ──────────────────────────────────────────────────────────────────
info()    { echo -e "${BLUE}ℹ${RESET}  $*"; }
success() { echo -e "${GREEN}✓${RESET}  $*"; }
warn()    { echo -e "${YELLOW}⚠${RESET}  $*"; }
error()   { echo -e "${RED}✖${RESET}  $*"; }
header()  { echo -e "\n${BOLD}${CYAN}$*${RESET}"; }
divider() { echo -e "${CYAN}────────────────────────────────────────${RESET}"; }

# ── Arguments ────────────────────────────────────────────────────────────────
SKIP_VERIFY=false
FORCE_PUSH=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --no-verify) SKIP_VERIFY=true; shift ;;
    --force)     FORCE_PUSH=true; shift ;;
    *)           shift ;;
  esac
done

# ── Initial Checks ───────────────────────────────────────────────────────────
header "🚀 Shoperzz — Secure Push Protocol"
divider

# Check if we are in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  error "This directory is not a git repository."
  exit 1
fi

LOCAL_BRANCH=$(git branch --show-current)
if [[ -z "$LOCAL_BRANCH" ]]; then
  error "You are in 'detached HEAD' mode. Return to a branch before pushing."
  exit 1
fi

# ── 1. Synchronization Check ────────────────────────────────────────────────
header "🔄 Step 1: Synchronization check"

info "Checking connection to upstream..."
if git remote get-url upstream > /dev/null 2>&1; then
  git fetch upstream develop --quiet
  BEHIND=$(git rev-list --count "HEAD..upstream/develop")
  
  if [[ "$BEHIND" -gt 0 ]]; then
    warn "Your branch is ${BOLD}$BEHIND commit(s) behind${RESET} upstream/develop."
    error "Please run 'pnpm sync' before pushing."
    exit 1
  fi
  success "Branch is synchronized with upstream/develop."
else
  warn "Remote 'upstream' not found. Skipping sync check."
fi

# ── 2. Local Validation ──────────────────────────────────────────────────────
if [[ "$SKIP_VERIFY" == "true" ]]; then
  warn "Skipping local validation (--no-verify)..."
else
  header "🧪 Step 2: Quality validation (Turbo)"
  
  info "Running lint, typecheck and tests..."
  if pnpm lint && pnpm typecheck && pnpm test; then
    success "All quality checks passed."
  else
    error "Quality checks failed. Fix errors before pushing."
    exit 1
  fi
fi

# ── 3. Changeset Verification ────────────────────────────────────────────────
header "🦋 Step 3: Changeset verification"

# Check if files in packages/ or plugins/ have changed
FILES_CHANGED=$(git diff --name-only upstream/develop...HEAD 2>/dev/null || git diff --name-only origin/develop...HEAD 2>/dev/null || git diff --name-only main...HEAD)

if echo "$FILES_CHANGED" | grep -E "^(packages|plugins)/" > /dev/null; then
  info "Detected changes in packages or plugins."
  
  # Check if a new changeset file exists in this branch
  CHANGESET_EXISTS=$(git diff --name-only upstream/develop...HEAD 2>/dev/null | grep ".changeset/.*\.md" || true)
  
  if [[ -z "$CHANGESET_EXISTS" ]]; then
    warn "No changeset detected for package/plugin changes."
    read -rp "  Would you like to run 'pnpm changeset' now? (Y/n) " RUN_CHANGESET
    if [[ "$RUN_CHANGESET" != "n" && "$RUN_CHANGESET" != "N" ]]; then
      pnpm changeset
      success "Changeset created. Please commit it before pushing if not automated."
    else
      warn "Proceeding without changeset (not recommended for releases)."
    fi
  else
    success "Changeset detected."
  fi
else
  info "No package/plugin changes detected. Skipping changeset check."
fi

# ── 4. Atomic Protocol Reminder ──────────────────────────────────────────────
header "⚛️  Step 4: Atomic Commit Protocol"
info "Remember: One intention per commit. No sensitive data. Public scope."
divider

# ── 5. Push ──────────────────────────────────────────────────────────────────
header "📤 Step 5: Pushing to origin"

PUSH_CMD="git push origin $LOCAL_BRANCH"
[[ "$FORCE_PUSH" == "true" ]] && PUSH_CMD="$PUSH_CMD --force-with-lease"

info "Executing: ${BOLD}$PUSH_CMD${RESET}"

if $PUSH_CMD; then
  echo ""
  success "Successfully pushed to origin/$LOCAL_BRANCH!"
  info "Next step: Open a Pull Request on GitHub if not already done."
  divider
else
  error "Push failed. Check if you need to use --force (if you rebased recently)."
  exit 1
fi
