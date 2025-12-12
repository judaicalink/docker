#!/bin/bash
set -e

# 1. wait for DB
/app/wait-for-it.sh "$DATABASE_HOST:$DATABASE_PORT" --timeout=60 -- echo "DB is up"

# 2. migrations & static
cd /app/labs
python manage.py migrate --no-input
python manage.py collectstatic --no-input

# 3. optional: create superuser only if it doesn't exist
if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
  echo "Ensuring superuser $DJANGO_SUPERUSER_USERNAME exists..."

  python manage.py shell <<EOF
from django.contrib.auth import get_user_model
User = get_user_model()
username = "${DJANGO_SUPERUSER_USERNAME}"
if not User.objects.filter(username=username).exists():
    print("Creating superuser:", username)
    User.objects.create_superuser(
        username=username,
        email="${DJANGO_SUPERUSER_EMAIL:-admin@example.com}",
        password="${DJANGO_SUPERUSER_PASSWORD}"
    )
else:
    print("Superuser", username, "already exists.")
EOF
fi

# 4. start the actual server (Daphne)
echo "Starting server: $@"
exec "$@"
