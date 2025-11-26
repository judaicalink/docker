#!/bin/bash
set -e

echo "📦 Copying generated data to shared volume..."
mkdir -p /data/generators/
cp -r /app/* /data/generators/

echo "✅ Data copied to /data/generators/"
echo "🚀 Starting generation process..."
python3 run_dataset.py --all #--load we leave it for now

echo "✅ Generation finished."

echo "Shutting down generator container."

#echo "Container will stay alive."
#tail -f /dev/null