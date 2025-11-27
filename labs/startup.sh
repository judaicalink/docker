#!/usr/bin/env bash
set -eio pipefail
/app/wait-for-it.sh localhost:5432

python manage.py makemigrations --no-input
python manage.py migrate --no-input
python manage.py collectstatic --no-input
python manage.py createsuperuser --no-input || true
daphne --bind 0.0.0.0 -p 8001 labs.asgi:application
