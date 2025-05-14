#!/bin/bash
set -e

timestamp=$(date +%Y-%m-%d_%H-%M-%S)
backup_dir="$SAMBA_BACKUP_DIR/triples-backups"
mkdir -p "$backup_dir"

echo "📦 Compressing RDF triple dumps..."
tar -czf "$backup_dir/triples-$timestamp.tar.gz" -C "$TRIPLES_DIR" .

find "$backup_dir" -name "triples-*.tar.gz" -type f -mtime +${BACKUP_RETENTION_DAYS} -delete

echo "✅ Triple dump backup complete."
