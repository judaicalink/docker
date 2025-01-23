#!/bin/bash

CORES=("judaicalink" "cm" "cm_meta" "cm_entities" "cm_entity_names" "judaicalink-beta")

# Start Solr in the background
solr start

# Loop through cores and create them
for CORE in "${CORES[@]}"; do
    echo "Creating core: $CORE"
    mkdir /var/solr/data/$CORE/conf
    solr create_core -c $CORE -d /var/solr/data/$CORE/conf
done

for CORE in "${CORES[@]}"; do
    echo "Uploading index data for $CORE"
    curl -X POST -H "Content-Type: application/json" \
        --data-binary @/var/solr/data/$CORE/index.json \
        "http://localhost:8983/solr/$CORE/update?commit=true"
done

# Reload cores to ensure they are indexed correctly
for CORE in "${CORES[@]}"; do
    echo "Reloading core: $CORE"
    curl "http://localhost:8983/solr/admin/cores?action=RELOAD&core=$CORE"
done

# Bring Solr to the foreground
solr-foreground
