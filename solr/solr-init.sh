#!/bin/bash
set -e

#solr start -f

echo "Waiting for Solr to start..."
timeout 60 bash -c 'until curl -s http://localhost:8983/solr/; do sleep 5; done'

if [ $? -ne 0 ]; then
  echo "SOLR did not start in time. Exiting."
  exit 1
fi

: '
echo "Creating cores..."
solr create -c judaicalink #-d _default
solr create -c judaicalink-beta #-d _default
solr create -c cm #-d _default
solr create -c cm_meta #-d _default
solr create -c cm_entities #-d _default
solr create -c cm_entity_names #-d _default

echo "Cores created successfully!"

#solr start -f
'

echo "Loading JSON data into cores..."
curl -X POST -H "Content-Type: application/json" \
     --data-binary @/data.json \
     "http://localhost:8983/solr/judaicalink/update?commit=true"

curl -X POST -H "Content-Type: application/json" \
     --data-binary @/data.json \
     "http://localhost:8983/solr/cm/update?commit=true"
