#!/bin/bash
set -e

echo "📦 Copying generated data to shared volume..."
mkdir -p /data/generators/
cp -r /app/* /data/generators/
echo "✅ Data copied to /data/generators/"

echo "✅ Generation finished. Container will stay alive."
tail -f /dev/null