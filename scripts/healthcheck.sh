#!/usr/bin/env bash

# ==============================================================================
# City Civic — Automated System Health Check & Readiness Probe
# Verifies Backend REST API, Database connectivity, and Admin portal.
# ==============================================================================

set -eo pipefail

BACKEND_URL="${BACKEND_URL:-http://localhost:5000}"
ADMIN_URL="${ADMIN_URL:-http://localhost:5173}"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Starting City Civic Health Probes ===${NC}"

# 1. Check Backend API Root
echo -n "Checking Backend API (${BACKEND_URL}/)... "
if BACKEND_RES=$(curl -s -o /dev/null -w "%{http_code}" "${BACKEND_URL}/" 2>/dev/null); then
  if [ "$BACKEND_RES" -eq 200 ]; then
    echo -e "${GREEN}[OK] (HTTP ${BACKEND_RES})${NC}"
  else
    echo -e "${RED}[FAIL] (HTTP ${BACKEND_RES})${NC}"
    exit 1
  fi
else
  echo -e "${RED}[UNREACHABLE] Backend service is down.${NC}"
  exit 1
fi

# 2. Check Complaints Endpoint
echo -n "Checking Complaints API (${BACKEND_URL}/api/complaints)... "
if COMPLAINTS_RES=$(curl -s -o /dev/null -w "%{http_code}" "${BACKEND_URL}/api/complaints" 2>/dev/null); then
  if [ "$COMPLAINTS_RES" -eq 200 ]; then
    echo -e "${GREEN}[OK] (HTTP ${COMPLAINTS_RES})${NC}"
  else
    echo -e "${RED}[FAIL] (HTTP ${COMPLAINTS_RES})${NC}"
    exit 1
  fi
else
  echo -e "${RED}[UNREACHABLE] Complaints endpoint unreachable.${NC}"
  exit 1
fi

# 3. Check Admin Dashboard Reachability
echo -n "Checking Admin Dashboard (${ADMIN_URL})... "
if ADMIN_RES=$(curl -s -o /dev/null -w "%{http_code}" "${ADMIN_URL}" 2>/dev/null); then
  if [ "$ADMIN_RES" -eq 200 ] || [ "$ADMIN_RES" -eq 304 ]; then
    echo -e "${GREEN}[OK] (HTTP ${ADMIN_RES})${NC}"
  else
    echo -e "${YELLOW}[WARN] Returned HTTP ${ADMIN_RES} (may require compilation)${NC}"
  fi
else
  echo -e "${YELLOW}[SKIP] Admin dev server not currently running.${NC}"
fi

echo -e "${GREEN}=== All Critical City Civic Services Healthy ===${NC}"
exit 0
