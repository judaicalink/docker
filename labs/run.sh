#!/bin/bash

# This script is used to run the Judaicalink Labs docker container

# Run migrations
python manage.py migrate

# Install node modules
#npm install -g npm@latest
#npm cache clean --force && npm install
npm install
npm run build


# Collect static files
python manage.py collectstatic --no-input

# Set CMD to start Daphne
#CMD ["daphne", "--bind", "0.0.0.0", "-p", "8000", "labs.asgi:application"]
daphne -p 8000 labs.asgi:application &