#!/usr/bin/env bash

# ==============================================================================
# City Civic — Automated Database Seed & Demo Data Bootstrapper
# Populates MongoDB with default administrators, citizens, and civic complaints.
# ==============================================================================

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="${SCRIPT_DIR}/../backend"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== Starting City Civic Database Seeding ===${NC}"

# Verify Backend Directory
if [ ! -d "${BACKEND_DIR}" ]; then
  echo -e "\033[0;31mError: Backend directory not found at ${BACKEND_DIR}\033[0m"
  exit 1
fi

cd "${BACKEND_DIR}"

# Check for .env file
if [ ! -f ".env" ]; then
  if [ -f ".env.example" ]; then
    echo -e "${YELLOW}Warning: .env not found. Copying .env.example to .env...${NC}"
    cp .env.example .env
  fi
fi

# Execute seed script
echo -e "${YELLOW}Executing seed script (node seedData.js)...${NC}"
node seedData.js

echo -e "${GREEN}=== Database Seeding Complete ===${NC}"
echo -e "Default credentials seeded:"
echo -e "  Admin: ${BLUE}admin@citycivic.com${NC} / ${YELLOW}Admin@123${NC}"
echo -e "  User:  ${BLUE}user@citycivic.com${NC}  / ${YELLOW}User@123${NC}"
