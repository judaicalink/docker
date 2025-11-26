#!/bin/bash
set -e

echo "📦 Waiting for Fuseki to be ready..."
until curl -sf "$FUSEKI_SERVER$/ping"; do
  echo "⏳ Waiting for Fuseki..."
  sleep 2
done

echo "📦 Checking for the 'judaicalink' dataset..."
# Check if the dataset already exists
if ! curl -sf "$FUSEKI_SERVERjudaicalink" >/dev/null; then
  echo "📥 Creating 'judaicalink' dataset..."
  curl -u "$FUSEKI_USER:$FUSEKI_PASSWORD" -X POST "$FUSEKI_SERVER$/datasets" \
       -d "dbName=judaicalink" -d "dbType=tdb2"
  echo "✅ Dataset 'judaicalink' created."
else
  echo "✅ Dataset 'judaicalink' already exists."
fi

echo "📋 Listing all datasets..."
curl -s -u $FUSEKI_USER:$FUSEKI_PASSWORD "$FUSEKI_SERVER$/datasets"

echo "🚀 Running loader script ..."
python /app/loader/loader.py || echo "⚠️ Loader failed, but container will stay alive."


echo "📦 Copying loader files to shared volume..."
cp -r /app/loader/ $LOADER_DIR

echo "✅ Loader finished."
#tail -f /dev/null  # Container will stay alive
