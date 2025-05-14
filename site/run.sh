#!/bin/bash
set -e

echo "📁 Creating target directory if it doesn't exist..."
mkdir -p /data/web.judaicalink.org/judaicalink-site/content/

echo "🏗️  Building Hugo site..."
hugo --minify

echo "📦 Copying generated site to /data/web.judaicalink.org/judaicalink-site..."
cp -r /app/* /data/web.judaicalink.org/judaicalink-site/

echo "🚀 Starting Hugo server..."
exec hugo server --bind 0.0.0.0 --baseURL=http://localhost --port=80 --appendPort=false
