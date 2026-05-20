#!/bin/bash
# ── Gestionnaire d'Intention de Version Shoperzz ────────────────────────────
# Ce script pilote Changeset pour créer des intentions de release.

set -e

# Couleurs
NC='\033[ NC='\033[0m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'

header() {
  echo -e "\n${CYAN}🚀 Shoperzz — Intent Manager${NC}"
  echo -e "${CYAN}────────────────────────────────────────${NC}"
}

# 1. Menu principal
header
echo -e "Quelle est l'intention de ce changement ?"
echo -e "  [1] ${GREEN}Prerelease${NC} (Alpha, Beta, RC)"
echo -e "  [2] ${GREEN}Patch${NC}      (Bugs, corrections mineures)"
echo -e "  [3] ${GREEN}Minor${NC}      (Nouvelles fonctionnalités)"
echo -e "  [4] ${GREEN}Major${NC}      (Changements majeurs, ruptures)"
echo -e "  [q] Quitter"

read -p "Votre choix : " INTENT

case $INTENT in
  1)
    echo -e "\nType de prerelease :"
    echo -e "  [a] alpha"
    echo -e "  [b] beta"
    echo -e "  [r] rc"
    read -p "Choix : " PRE_TYPE
    TAG="alpha"
    [[ "$PRE_TYPE" == "b" ]] && TAG="beta"
    [[ "$PRE_TYPE" == "r" ]] && TAG="rc"

    echo -e "\n${BLUE}ℹ  Passage en mode PRE (${TAG})...${NC}"
    # On entre en mode PRE (Changeset gère le fichier pre.json s'il n'existe pas)
    pnpm changeset pre enter $TAG
    
    echo -e "${BLUE}ℹ  Création du changeset...${NC}"
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
    echo "Opération annulée."
    exit 0
    ;;
esac

echo -e "\n${GREEN}✓  Intention enregistrée avec succès.${NC}"
