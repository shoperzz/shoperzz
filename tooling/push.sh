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

# ── 0. Initial Status & Formatting Check ─────────────────────────────────────
header "✨ Step 0: Integrity check"

# Function to get core version
get_core_version() {
  node -p "require('./packages/core/package.json').version"
}

# Identify different types of uncommitted changes
DIRTY_CHANGESETS=$(git status --porcelain | grep ".changeset/.*\.md" | awk '{print $2}' || true)
DIRTY_CODE=$(git status --porcelain | grep -v ".changeset/.*\.md" | awk '{print $2}' || true)

# Handle existing Changesets (Proactive Automation)
if [[ -n "$DIRTY_CHANGESETS" ]]; then
  warn "Uncommitted changesets detected:"
  echo -e "${YELLOW}$DIRTY_CHANGESETS${RESET}"
  VERSION=$(get_core_version)
  read -rp "  Apply automated commit 'chore(release): dump v$VERSION'? (Y/n) " AUTO_COMMIT_CS
  if [[ "$AUTO_COMMIT_CS" != "n" && "$AUTO_COMMIT_CS" != "N" ]]; then
    echo "$DIRTY_CHANGESETS" | xargs git add
    git commit -m "chore(release): dump v$VERSION"
    success "Changesets committed."
    # Refresh dirty code list
    DIRTY_CODE=$(git status --porcelain | grep -v ".changeset/.*\.md" | awk '{print $2}' || true)
  fi
fi

# Run Formatting
info "Running automated formatting..."
FILES_DIRTY_BEFORE=$(git diff --name-only)
pnpm format --write > /dev/null 2>&1 || true
FILES_DIRTY_AFTER=$(git diff --name-only)

# Identify files specifically fixed by Prettier
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
    error "Push blocked: Formatting fixes must be committed."
    exit 1
  fi
fi

# Final blocker: Check for any remaining dirty code
DIRTY_REMAINING=$(git status --porcelain | grep -vE "^  " || true)
if [[ -n "$DIRTY_REMAINING" ]]; then
  divider
  error "PUSH BLOCKED: You have uncommitted code changes."
  echo "$DIRTY_REMAINING"
  divider
  info "RODIN Protocol requires all functional changes to be committed manually."
  info "Please review and commit your work before pushing."
  exit 1
fi

success "Integrity check passed."

# ── 1. Synchronization Check ────────────────────────────────────────────────
header "🔄 Step 1: Synchronization check"

info "Checking connection to upstream..."
if git remote get-url upstream > /dev/null 2>&1; then
  git fetch upstream dev --quiet
  BEHIND=$(git rev-list --count "HEAD..upstream/dev")
  
  if [[ "$BEHIND" -gt 0 ]]; then
    warn "Your branch is ${BOLD}$BEHIND commit(s) behind${RESET} upstream/dev."
    error "Please run 'pnpm sync' before pushing."
    exit 1
  fi
  success "Branch is synchronized with upstream/dev."
else
  warn "Remote 'upstream' not found. Skipping sync check."
fi

# ── 2. Local Validation ──────────────────────────────────────────────────────
if [[ "$SKIP_VERIFY" == "true" ]]; then
  warn "Skipping local validation (--no-verify)..."
else
  header "🧪 Step 2: Quality validation (Turbo)"
  
  info "Running lint, typecheck, tests and commitlint..."
  if pnpm lint && pnpm typecheck && pnpm test && pnpm commitlint --from main; then
    success "All quality checks passed."
  else
    error "Quality checks failed. Fix errors before pushing."
    exit 1
  fi
fi

# ── 3. Changeset Verification ────────────────────────────────────────────────
header "🦋 Step 3: Changeset verification"

# Check if files in packages/ or plugins/ have changed
FILES_CHANGED=$(git diff --name-only upstream/dev...HEAD 2>/dev/null || git diff --name-only origin/dev...HEAD 2>/dev/null || git diff --name-only main...HEAD)

if echo "$FILES_CHANGED" | grep -E "^(packages|plugins)/" > /dev/null; then
  info "Detected changes in packages or plugins."
  
  # Check if a new changeset file exists in this branch
  CHANGESET_EXISTS=$(git diff --name-only upstream/dev...HEAD 2>/dev/null | grep ".changeset/.*\.md" || true)
  
  if [[ -z "$CHANGESET_EXISTS" ]]; then
    warn "No changeset detected for package/plugin changes."
    read -rp "  Would you like to run 'pnpm changeset' now? (Y/n) " RUN_CHANGESET
    if [[ "$RUN_CHANGESET" != "n" && "$RUN_CHANGESET" != "N" ]]; then
      # Identify changeset files BEFORE running the command
      CHANGESETS_BEFORE=$(ls .changeset/*.md 2>/dev/null || true)
      
      pnpm changeset
      success "Changeset created."
      
      # Identify the specific NEW changeset file
      CHANGESETS_AFTER=$(ls .changeset/*.md 2>/dev/null || true)
      NEW_CHANGESET=$(comm -13 <(echo "$CHANGESETS_BEFORE" | sort) <(echo "$CHANGESETS_AFTER" | sort))
      
      if [[ -n "$NEW_CHANGESET" ]]; then
        # Extract core version for a professional commit message
        CURRENT_VERSION=$(node -p "require('./packages/core/package.json').version")
        
        read -rp "  Would you like to commit the new changeset ($NEW_CHANGESET) automatically? (Y/n) " AUTO_COMMIT_CHANGESET
        if [[ "$AUTO_COMMIT_CHANGESET" != "n" && "$AUTO_COMMIT_CHANGESET" != "N" ]]; then
          git add "$NEW_CHANGESET"
          git commit -m "chore(release): prepare v$CURRENT_VERSION"
          success "Changeset $NEW_CHANGESET committed."
        else
          warn "New changeset $NEW_CHANGESET is not committed."
        fi
      fi
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
