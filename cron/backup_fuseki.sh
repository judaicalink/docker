#!/bin/bash
set -e

timestamp=$(date +%Y-%m-%d_%H-%M-%S)
backup_dir="$SAMBA_BACKUP_DIR/fuseki-backups"
mkdir -p "$backup_dir"

echo "📦 Compressing Fuseki backup..."
tar -czf "$backup_dir/fuseki-$timestamp.tar.gz" -C "$FUSEKI_DATA" .

# Remove backups older than X days
find "$backup_dir" -name "fuseki-*.tar.gz" -type f -mtime +${BACKUP_RETENTION_DAYS} -delete

echo "✅ Fuseki backup complete."
