#!/bin/bash
echo "[$(date)] Updating AWStats..."
docker exec awstats update-awstats.sh site
docker exec awstats update-awstats.sh labs
docker exec awstats update-awstats.sh pubby
