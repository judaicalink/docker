#!/bin/bash
set -e

SUBJECT="$1"
BODY="The backup task '$SUBJECT' failed on $(hostname) at $(date). Please check the logs."

echo "$BODY" | mail -s "$SUBJECT" "$ADMIN_EMAIL"
