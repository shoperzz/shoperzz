#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# push.sh — "Elite" Push Orchestrator for Shoperzz Monorepo
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

# ── Colors & Style ───────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${BLUE}ℹ${RESET}  $*"; }
success() { echo -e "${GREEN}✓${RESET}  $*"; }
warn()    { echo -e "${YELLOW}⚠${RESET}  $*"; }
error()   { echo -e "${RED}✖${RESET}  $*"; }
header()  { echo -e "\n${BOLD}${CYAN}$*${RESET}"; }
divider() { echo -e "${CYAN}────────────────────────────────────────${RESET}"; }

# ── STEP 0: Integrity & Version Audit ────────────────────────────────────────
header "✨ Step 0: Version & Git Audit"

# 1. Branch verification
LOCAL_BRANCH=$(git branch --show-current)
if [[ -z "$LOCAL_BRANCH" ]]; then
  error "You are in 'detached HEAD' mode. Please return to a branch."
  exit 1
fi

# 2. Call Audit Module (Verifies GitHub Tags vs Local)
bash ./tooling/audit/version-audit.sh || {
  divider
  error "ABORTED: Version inconsistency detected."
  info "Please resolve the conflict manually or via 'git pull' before pushing."
  exit 1
}

# ── STEP 1: Formatting Audit (Surgical) ──────────────────────────────────────
header "✨ Step 1: Formatting Audit"

FILES_DIRTY_BEFORE=$(git diff --name-only)
info "Running Prettier on modified files..."
pnpm format > /dev/null 2>&1 || true
FILES_DIRTY_AFTER=$(git diff --name-only)

# Identify files fixed by Prettier
FILES_FIXED=$(comm -13 <(echo "$FILES_DIRTY_BEFORE" | sort) <(echo "$FILES_DIRTY_AFTER" | sort))

if [[ -n "$FILES_FIXED" ]]; then
  warn "Formatting corrections applied to:"
  echo -e "${YELLOW}$FILES_FIXED${RESET}"
  read -rp "  Commit these style fixes automatically? (Y/n) " AUTO_COMMIT_FORMAT
  if [[ "$AUTO_COMMIT_FORMAT" != "n" && "$AUTO_COMMIT_FORMAT" != "N" ]]; then
    echo "$FILES_FIXED" | xargs git add
    git commit -m "style: format code according to standards"
    success "Formatting committed."
  else
    error "Push blocked: Style fixes must be committed."
    exit 1
  fi
fi

# ── STEP 2: Intent & Release Management ──────────────────────────────────────
header "✨ Step 2: Intent & Release Management (Changesets)"

# Detect existing changesets
CHANGESETS=$(ls .changeset/*.md 2>/dev/null | grep -v "README.md" || true)

if [[ -z "$CHANGESETS" ]]; then
  warn "No changeset detected. Your changes will NOT be versioned."
  read -p "Would you like to declare a release intent now? (Y/n) " ADD_INTENT
  if [[ "$ADD_INTENT" =~ ^[Yy]$ ]]; then
    # Call Intent Module
    bash ./tooling/version/manage-intent.sh
    
    # Get predicted version for the commit message
    NEXT_VERSION=$(./tooling/version/get-next-version.sh)
    
    read -p "Would you like to commit this intent (v${NEXT_VERSION}) automatically? (Y/n) " AUTO_COMMIT
    if [[ "$AUTO_COMMIT" =~ ^[Yy]$ || -z "$AUTO_COMMIT" ]]; then
       git add .changeset/*.md .changeset/pre.json 2>/dev/null || true
       git commit -m "chore(release): v${NEXT_VERSION}"
       success "Intent v${NEXT_VERSION} committed."
    fi
  fi
else
  info "Changesets detected: $(echo $CHANGESETS | wc -w) file(s)."
fi

# ── STEP 3: Final Security Check (RODIN Protocol) ────────────────────────────
header "✨ Step 3: RODIN Security Audit"

# Block if there's remaining "dirty" code (uncommitted functional changes)
# We ignore changeset files and package.json which are managed by the bot
DIRTY_REMAINING=$(git status --porcelain | grep -vE "^( |M| ) (.changeset/|package\.json)" || true)

if [[ -n "$DIRTY_REMAINING" ]]; then
  divider
  error "PUSH BLOCKED: You have uncommitted functional changes."
  echo "$DIRTY_REMAINING"
  divider
  info "RODIN Protocol requires all functional changes to be manually committed."
  exit 1
fi

# ── STEP 4: Upstream Synchronization ─────────────────────────────────────────
header "🔄 Step 4: Synchronization Audit"

if git remote | grep -q "origin"; then
    info "Checking alignment with origin/$LOCAL_BRANCH..."
    git fetch origin "$LOCAL_BRANCH" > /dev/null 2>&1 || true
    
    BEHIND_COUNT=$(git rev-list --count HEAD..origin/"$LOCAL_BRANCH" 2>/dev/null || echo 0)
    if [ "$BEHIND_COUNT" -gt 0 ]; then
        error "Your branch is $BEHIND_COUNT commit(s) behind GitHub."
        info "Please run 'pnpm sync' to align before pushing."
        exit 1
    fi
    success "Branch is perfectly synchronized."
fi

# ── STEP 5: Final Push ───────────────────────────────────────────────────────
header "🚀 Step 5: Pushing to GitHub"

info "Pushing $LOCAL_BRANCH to origin..."

if git push origin "$LOCAL_BRANCH"; then
    divider
    success "Push successful!"
    info "Shoperzz Infrastructure is secure."
    divider
else
    error "Push failed. Check connectivity or branch permissions."
    exit 1
fi
