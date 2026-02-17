#!/usr/bin/env bash

# -------- Colors --------
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

clear
echo -e "${BLUE}=====================================${NC}"
echo -e "${PURPLE}        Hyprbuti Installer${NC}"
echo -e "${BLUE}=====================================${NC}"

bash scripts/install-packages.sh
bash scripts/install-dotfiles.sh

echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}        Setup Complete! ${NC}"
echo -e "${GREEN}=====================================${NC}"
