#!/bin/bash
set -e

SOLR_URL="http://localhost:8983/solr"
DATA_DIR="/app/indices"
CORES=("cm" "cm_meta" "cm_entities" "cm_entity_names" "judaicalink" "judaicalink-beta")

echo "📦 Creating Solr cores if they do not exist..."

for core in "${CORES[@]}"; do
  if [ ! -d "/var/solr/data/$core" ]; then
    echo "🔧 Creating core: $core"

    if [ -f "$HOST_SCHEMA_DIR/$CORE/conf/managed-schema.xml" ]; then
    echo "Copying schema for $CORE..."
    cp "$HOST_SCHEMA_DIR/$CORE/conf/managed-schema.xml" "$CORE_DIR/conf/managed-schema"
  else
    echo "Warning: Schema for $CORE not found."
        precreate-core "$core"
  fi

    #echo "name=$CORE" > "$CORE_DIR/core.properties"
  else
    echo "✅ Core $core already exists"
  fi
done

echo "Loading cores into Solr..."

for core in "${CORES[@]}"; do
  if [ ! -f \"/var/solr/data/$core/core.properties\" ]; then
    echo "name=$core" > "/var/solr/data/$core/core.properties"
  fi
done

echo "🚀 Starting Solr in background..."
solr start -f &
SOLR_PID=$!

# Warte, bis Solr verfügbar ist
echo "⏳ Waiting for Solr to be available..."
until curl -s "$SOLR_URL/admin/cores?action=STATUS" | grep -q '"numDocs"'; do
  echo "⏳ Waiting for Solr to be ready..."
  sleep 2
done

echo "✅ Solr is ready."

# Lade alle .json-Dateien, die zu einem Core passen
for file in "$DATA_DIR"/*.json; do
  [ -e "$file" ] || continue
  core_name=$(basename "$file" .json)

  # Prüfe, ob es ein bekannter Core ist
  if [[ " ${CORES[*]} " == *" $core_name "* ]]; then
    echo "📥 Uploading $file to core $core_name..."
    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
      "$SOLR_URL/$core_name/update?commit=true" \
      -H "Content-Type: application/json" \
      --data-binary @"$file")

    if [[ "$response" == "200" ]]; then
      echo "✅ Successfully uploaded $file to core $core_name"
    else
      echo "❌ Failed to upload $file to $core_name (HTTP $response)"
    fi
  else
    echo "⚠️ Skipping $file – no matching core defined"
  fi
done

echo "🎉 Initialization complete. Solr will stay running."

# Halte Solr im Vordergrund
wait $SOLR_PID
