#!/bin/bash
set -e

echo "📥 Downloading Compact Memory fulltexts..."

# Create target dirs
mkdir -p /app/cm/txt
mkdir -p /app/cm/xml
mkdir -p /app/cm/metadata

echo "Download Compact Memory files"
# Download TXT files
#echo "⬇️ Downloading TXT..."
#wget -r -nH --cut-dirs=2 --no-parent --reject "index.html*" -P /app/cm/txt https://labs.judaicalink.org/fulltexts/txt/

# Download XML files
#echo "⬇️ Downloading XML..."
#wget -r -nH --cut-dirs=2 --no-parent --reject "index.html*" -P /app/cm/xml https://labs.judaicalink.org/fulltexts/xml/

# Download Metadata files (assumed location, can be changed)
echo "⬇️ Downloading Metadata..."
wget -r -nH --cut-dirs=2 --no-parent --reject "index.html*" -P /app/cm/metadata https://labs.judaicalink.org/fulltexts/metadata/

# Confirm downloads
echo "📁 Downloaded structure:"
find /app/cm

# Copy to volume
echo "📦 Copying everything to /data/cm/..."
mkdir -p /data/cm/

cp -r /app/cm $CM_DATA_DIR

echo "✅ All data copied."

# Keep the container running (optional for debugging)
#tail -f /dev/null
