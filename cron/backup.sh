#!/bin/bash
set -e

# Load environment variables (for cron)
if [ -f /etc/environment ]; then
    export $(cat /etc/environment | xargs)
fi

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
DB_FILE="${BACKUP_DIR}/database/xenforo_db_${DATE}.sql.gz"
mariadb-dump -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASS}" \
    --single-transaction --quick --lock-tables=false \
    "${DB_NAME}" | gzip -1 > "${DB_FILE}"

# Verify database backup
if [ ! -s "${DB_FILE}" ]; then
    echo "[$(date)] ERROR: Database backup failed - file is empty"
    rm -f "${DB_FILE}"
    exit 1
fi
echo "[$(date)] Database backup completed: $(basename ${DB_FILE}) ($(du -h ${DB_FILE} | cut -f1))"

# Files backup (entire public folder)
echo "[$(date)] Starting files backup..."
FILES_FILE="${BACKUP_DIR}/files/xenforo_files_${DATE}.tar.gz"
tar -czf "${FILES_FILE}" -C /var/www/html public

# Verify files backup
if ! tar -tzf "${FILES_FILE}" > /dev/null 2>&1; then
    echo "[$(date)] ERROR: Files backup failed - archive is corrupt"
    rm -f "${FILES_FILE}"
    exit 1
fi
echo "[$(date)] Files backup completed: $(basename ${FILES_FILE}) ($(du -h ${FILES_FILE} | cut -f1))"

# Cleanup old backups
echo "[$(date)] Cleaning up backups older than ${RETENTION_DAYS} days..."
find "${BACKUP_DIR}/database" -name "*.sql.gz" -mtime +${RETENTION_DAYS} -delete
find "${BACKUP_DIR}/files" -name "*.tar.gz" -mtime +${RETENTION_DAYS} -delete

echo "[$(date)] Backup completed successfully!"
