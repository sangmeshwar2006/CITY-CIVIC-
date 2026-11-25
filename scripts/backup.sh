#!/usr/bin/env bash

# ==============================================================================
# City Civic — Automated Database Backup & Gzip Archive Utility
# Creates timestamped BSON backups of MongoDB and purges snapshots older than 7 days.
# ==============================================================================

set -eo pipefail

BACKUP_DIR="${1:-/var/backups/city-civic}"
MONGODB_URI="${MONGODB_URI:-mongodb://127.0.0.1:27017/city-civic}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
TARGET_FOLDER="${BACKUP_DIR}/dump_${TIMESTAMP}"
ARCHIVE_NAME="city-civic-backup-${TIMESTAMP}.tar.gz"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Starting MongoDB Backup for City Civic ===${NC}"
mkdir -p "${BACKUP_DIR}"

# Execute mongodump
echo -e "Dumping database to ${TARGET_FOLDER}..."
if command -v mongodump >/dev/null 2>&1; then
  mongodump --uri="${MONGODB_URI}" --out="${TARGET_FOLDER}" --quiet
else
  echo -e "${YELLOW}mongodump not found in PATH. Using Docker fallback...${NC}"
  docker exec city-civic-mongodb mongodump --db=city-civic --out=/data/db/backup_tmp
  docker cp city-civic-mongodb:/data/db/backup_tmp "${TARGET_FOLDER}"
  docker exec city-civic-mongodb rm -rf /data/db/backup_tmp
fi

# Package and compress archive
echo -e "Compressing backup archive: ${ARCHIVE_NAME}..."
tar -czvf "${BACKUP_DIR}/${ARCHIVE_NAME}" -C "${TARGET_FOLDER}" . >/dev/null
rm -rf "${TARGET_FOLDER}"

# Retention cleanup (remove backups older than 7 days)
echo -e "Purging local backups older than 7 days..."
find "${BACKUP_DIR}" -name "city-civic-backup-*.tar.gz" -type f -mtime +7 -delete 2>/dev/null || true

echo -e "${GREEN}=== Backup Complete: ${BACKUP_DIR}/${ARCHIVE_NAME} ===${NC}"
