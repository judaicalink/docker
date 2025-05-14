#!/bin/bash
set -e

# ========== Configuration ==========
BACKUP_TYPE=$1       # solr | fuseki | triples
BACKUP_FILE=$2       # path to .tar.gz
TARGET_DIR=$3        # e.g. /var/solr/data or /fuseki/data or /data/dumps
FUSEKI_URL=${FUSEKI_URL:-http://localhost:3030}
FUSEKI_USER=${FUSEKI_USER:-admin}
FUSEKI_PASSWORD=${FUSEKI_PASSWORD:-admin}

# ========== Checks ==========
if [[ -z "$BACKUP_TYPE" || -z "$BACKUP_FILE" || -z "$TARGET_DIR" ]]; then
  echo "❌ Usage: $0 [solr|fuseki|triples] <backup.tar.gz> <target_dir>"
  exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
  echo "❌ Backup file '$BACKUP_FILE' not found."
  exit 1
fi

echo "⚠️ You are about to restore '$BACKUP_TYPE' to '$TARGET_DIR'"
read -p "❓ Are you sure you want to continue? [y/N] " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "❌ Restore cancelled."
  exit 1
fi

# ========== Action ==========
echo "🔧 Extracting $BACKUP_FILE..."
mkdir -p /tmp/restore
tar -xzf "$BACKUP_FILE" -C /tmp/restore

case "$BACKUP_TYPE" in
  solr)
    echo "📦 Restoring Solr data to $TARGET_DIR..."
    cp -r /tmp/restore/* "$TARGET_DIR/"
    echo "✅ Solr restore complete."
    ;;
  fuseki)
    echo "📦 Restoring Fuseki data to $TARGET_DIR..."
    cp -r /tmp/restore/* "$TARGET_DIR/"
    echo "✅ Fuseki restore complete."
    ;;
  triples)
    echo "📦 Restoring triple dumps to $TARGET_DIR..."
    cp -r /tmp/restore/* "$TARGET_DIR/"
    echo "✅ Triple dumps restore complete."
    ;;
  *)
    echo "❌ Unknown backup type: $BACKUP_TYPE"
    exit 1
    ;;
esac

# ========== Cleanup ==========
rm -rf /tmp/restore
