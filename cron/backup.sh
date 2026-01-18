#!/bin/bash
set -e

# Configuration
BACKUP_DIR="/backups"
RETENTION_DAYS=14
DATE=$(date +%Y%m%d_%H%M%S)
DB_HOST="mariadb"
DB_USER="root"
DB_PASS="${MARIADB_ROOT_PASSWORD}"
DB_NAME="xenforo"

# Create backup directory if not exists
mkdir -p "${BACKUP_DIR}/database"
mkdir -p "${BACKUP_DIR}/files"

# Database backup
echo "[$(date)] Starting database backup..."
mariadb-dump -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASS}" \
    --single-transaction --quick --lock-tables=false \
    "${DB_NAME}" | gzip > "${BACKUP_DIR}/database/xenforo_db_${DATE}.sql.gz"
echo "[$(date)] Database backup completed: xenforo_db_${DATE}.sql.gz"

# Files backup (internal_data and data folders - user uploads)
echo "[$(date)] Starting files backup..."
tar -czf "${BACKUP_DIR}/files/xenforo_files_${DATE}.tar.gz" \
    -C /var/www/html \
    internal_data data 2>/dev/null || true
echo "[$(date)] Files backup completed: xenforo_files_${DATE}.tar.gz"

# Cleanup old backups
echo "[$(date)] Cleaning up backups older than ${RETENTION_DAYS} days..."
find "${BACKUP_DIR}/database" -name "*.sql.gz" -mtime +${RETENTION_DAYS} -delete
find "${BACKUP_DIR}/files" -name "*.tar.gz" -mtime +${RETENTION_DAYS} -delete

echo "[$(date)] Backup completed successfully!"
