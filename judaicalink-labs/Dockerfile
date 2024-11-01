# Base image with Python and Node.js (for npm build step)
FROM python:3.10-slim AS base

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    gcc \
    curl \
    git \
    npm \
    && rm -rf /var/lib/apt/lists/*


# Set working directory
WORKDIR /app

# Clone the deployment branch of the repository
ARG GIT_REPO_URL
ARG GIT_BRANCH=solr
RUN git clone --branch $GIT_BRANCH $GIT_REPO_URL .

WORKDIR /app/labs

# Generate a random SECRET_KEY and write it to .env
RUN python -c "import secrets, string; alphabet = string.ascii_letters + string.digits + '!@#$%^&*(-_=+)'; print('SECRET_KEY=' + ''.join(secrets.choice(alphabet) for _ in range(50)))" > .env
RUN echo 'DEBUG=False' >> .env
RUN echo 'ALLOWED_HOSTS=localhost, 127.0.0.1' >> .env
RUN echo 'STATIC_URL=/static/' >> .env
RUN echo 'MEDIA_URL=/media/' >> .env
RUN echo 'MEDIA_ROOT=media/' >> .env
RUN echo 'STATIC_ROOT=static/' >> .env
ARG LOGFILE='django.log'
RUN echo "LOGFILE=${LOGFILE}" >> .env

# Add DATABASE_URL to the .env file
# Postgres Database
ARG DB_USER=judaicalink
ARG DB_PASSWORD=xO@X67B7J2Nq1bGYozCG
ARG DB_HOST=localhost
ARG DB_PORT=5432
ARG DB_NAME=judicalink-labs-db

#RUN echo "DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}" >> .env
#RUN echo "DATABASE_URL=postgres://judaicalink:xO@X67B7J2Nq1bGYozCG@postgres:5432/judicalink-labs-db" >> .env

# Add CACHE_URL to the .env file
ARG CACHE_URL=redis://localhost:6379/1

# Add DATABASE_URL to the .env file
RUN echo "CACHE_URL=${CACHE_URL}" >> .env

# Add REDIS_URL to the .env file
ARG REDIS_URL=redis://localhost:6379/0

RUN echo "REDIS_URL=${REDIS_URL}" >> .env

# Add EMAIL_BACKEND to the .env file
ARG EMAIL_BACKEND=django.core.mail.backends.console.EmailBackend
ARG EMAIL_HOST=localhost
ARG EMAIL_PORT=25
ARG EMAIL_HOST_USER=judaicalink
ARG EMAIL_HOST_PASSWORD=dummy
ARG EMAIL_USE_TLS=False
ARG EMAIL_USE_SSL=False
ARG EMAIL_TIMEOUT=60
ARG EMAIL_TO=b.schnabel@hs-mannheim.de
ARG DEFAULT_FROM_EMAIL=info@judaicalink.org
ARG LABS_ROOT='http://localhost:8000'
ARG FUSEKI_SERVER='http://localhost:3030'
ARG FUSEKI_STORAGE='.'
ARG LABS_GIT_WEBROOT=''
ARG LABS_DUMPS_WEBROOT=''
ARG LABS_DUMPS_LOCAL=''
ARG GEONAMES_API_USER=''
ARG ELASTICSEARCH_SERVER='http://localhost:9200'
ARG ELASTICSEARCH_USER=''
ARG ELASTICSEARCH_PASSWORD=''
ARG JUDAICALINK_INDEX='judaicalink'
ARG COMPACT_MEMORY_INDEX='cm'
ARG COMPACT_MEMORY_META_INDEX='cm_meta'
ARG HCAPTCHA_SITEKEY='8dec622e-0900-49ee-8bd6-c7c46b404ed8'
ARG HCAPTCHA_SECRET=''
ARG ELASTICSEARCH_SERVER_CERT_PATH='.'
ARG SOLR_SERVER='http://localhost:8983/solr'
ARG SOLR_CORE='judaicalink'
ARG SOLR_USER=''
ARG SOLR_PASSWORD=''


RUN echo "EMAIL_BACKEND=${EMAIL_BACKEND}" >> .env
RUN echo "EMAIL_HOST=${EMAIL_HOST}" >> .env
RUN echo "EMAIL_PORT=${EMAIL_PORT}" >> .env
RUN echo "EMAIL_HOST_USER=${EMAIL_HOST_USER}" >> .env
RUN echo "EMAIL_HOST_PASSWORD=${EMAIL_HOST_PASSWORD}" >> .env
RUN echo "EMAIL_USE_TLS=${EMAIL_USE_TLS}" >> .env
RUN echo "EMAIL_USE_SSL=${EMAIL_USE_SSL}" >> .env
RUN echo "EMAIL_TIMEOUT=${EMAIL_TIMEOUT}" >> .env
RUN echo "EMAIL_TO=${EMAIL_TO}" >> .env
RUN echo "DEFAULT_FROM_EMAIL=${DEFAULT_FROM_MAIL}" >> .env
RUN echo "LABS_ROOT=${LABS_ROOT}" >> .env
RUN echo "FUSEKI_SERVER=${FUSEKI_SERVER}" >> .env
RUN echo "FUSEKI_STORAGE=${FUSEKI_STORAGE}" >> .env
RUN echo "LABS_GIT_WEBROOT=${LABS_GIT_WEBROOT}" >> .env
RUN echo "LABS_DUMPS_WEBROOT=${LABS_DUMPS_WEBROOT}" >> .env
RUN echo "LABS_DUMPS_LOCAL=${LABS_DUMPS_LOCAL}" >> .env
RUN echo "GEONAMES_API_USER=${GEONAMES_API_USER}" >> .env
# Elasticsearch
RUN echo "ELASTICSEARCH_SERVER=${ELASTICSEARCH_SERVER}" >> .env
RUN echo "ELASTICSEARCH_USER=${ELASTICSEARCH_USER}" >> .env
RUN echo "ELASTICSEARCH_PASSWORD=${ELASTICSEARCH_PASSWORD}" >> .env
RUN echo "JUDAICALINK_INDEX=${JUDAICALINK_INDEX}" >> .env
RUN echo "COMPACT_MEMORY_INDEX=${COMPACT_MEMORY_INDEX}" >> .env
RUN echo "COMPACT_MEMORY_META_INDEX=${COMPACT_MEMORY_META_INDEX}" >> .env
RUN echo "ELASTICSEARCH_SERVER_CERT_PATH=${ELASTICSEARCH_SERVER_CERT_PATH}" >> .env
# hCaptcha
RUN echo "HCAPTCHA_SITEKEY=${HCAPTCHA_SITEKEY}" >> .env
RUN echo "HCAPTCHA_SECRET=${HCAPTCHA_SECRET}" >> .env
# Solr
RUN echo "SOLR_SERVER=${SOLR_SERVER}" >> .env
RUN echo "SOLR_CORE=${SOLR_CORE}" >> .env
RUN echo "SOLR_USER=${SOLR_USER}" >> .env
RUN echo "SOLR_PASSWORD=${SOLR_PASSWORD}" >> .env

WORKDIR /app/labs

# Copy sample.env to .env
RUN cp sample.env labs/.env
#RUN cp labs/localsettings.py.example labs/localsettings.py

WORKDIR /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app/labs

# Install npm dependencies and run build
RUN npm install
RUN npm run build

# Collect static files
RUN python manage.py collectstatic --noinput

# Apply migrations
RUN python manage.py migrate

# Expose the app port
EXPOSE 8000

# Command to start the app using Daphne
CMD ["daphne", "-p", "8000", "labs.asgi:application"]
