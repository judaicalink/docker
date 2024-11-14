#!/bin/bash

# This script runs the Judaicalink ontology pipeline

echo "Creating a new dataset in the triplestore"

# Create a new dataset in the triplestore
curl -u $FUSEKI_USER:$FUSEKI_PASSWORD -X POST http://fuseki:3030/\$/datasets -d "dbName=judaicalink" -d "dbType=tdb2"

# List all datasets in the triplestore
echo "Listing all datasets in the triplestore"
curl -u $FUSEKI_USER:$FUSEKI_PASSWORD http://fuseki:3030/\$/datasets -i

# Create a new graph in the triplestore
echo "Creating a new graph in the triplestore"
curl -X PUT -H "Content-Type: text/turtle" \
    -u $FUSEKI_USER:$FUSEKI_PASSWORD \
     http://fuseki:3030/judaicalink/data?graph=http://judaicalink.org/ontology

# Load the ttl file into the triplestore
echo "Loading data into the triplestore"

curl -u $FUSEKI_USER:$FUSEKI_PASSWORD -X POST http://fuseki:3030/judaicalink/data \
    -H 'Content-Type: text/turtle' \
    --data-binary '@./judaicalink-ontology.ttl'

echo "done"
