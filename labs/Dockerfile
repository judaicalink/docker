# Base image with Python
FROM python:3.12-slim AS base

# Install system dependencies
RUN apt-get update --yes --quiet --allow-releaseinfo-change && \
    apt-get install --yes --quiet --no-install-recommends --fix-missing \
    gnupg2 \
    debian-archive-keyring \
    ca-certificates \
    build-essential \
    libpq-dev \
    gcc \
    curl \
    git && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and configure pip for TLS/SSL
RUN python -m pip install --upgrade pip

# Set working directory
WORKDIR /app

# Clone the repository
ARG GIT_REPO_URL=https://github.com/judaicalink/judaicalink-labs.git
ARG GIT_BRANCH=master
RUN git config --global http.postBuffer 524288000 && \
    git config --global core.compression 0 && \
    git clone -b $GIT_BRANCH $GIT_REPO_URL /app/

# Move to the labs directory
WORKDIR /app/labs/

# Generate and populate the .env file

# Add additional environment variables
ARG DEBUG=False
ARG SECRET_KEY
ARG ALLOWED_HOSTS
ARG DJANGO_SETTINGS_MODULE=labs.settings
ARG INTERNAL_IPS
ARG STATIC_URL
ARG MEDIA_URL
ARG MEDIA_ROOT
ARG STATIC_ROOT
ARG LOGFILE

# DATABASE
ARG DATABASE_ENGINE
ARG DATABASE_USER
ARG DATABASE_PASSWORD
ARG DATABASE_DB
ARG DATABASE_HOST
ARG DATABASE_PORT

# Redis Cache
ARG CACHE_URL
ARG REDIS_URL
ARG REDIS_HOST
ARG REDIS_PORT
ARG REDIS_PASSWORD

# EMAIL
ARG EMAIL_BACKEND
ARG EMAIL_HOST
ARG EMAIL_PORT
ARG EMAIL_HOST_USER
ARG EMAIL_HOST_PASSWORD
ARG EMAIL_USE_TLS
ARG EMAIL_TO
ARG DEFAULT_FROM_EMAIL

# SOLR
ARG SOLR_SERVER
ARG SOLR_STORAGE
ARG SOLR_CORE
ARG SOLR_USER
ARG SOLR_PASSWORD
ARG SOLR_SERVER_CERT_PATH
ARG SOLR_SERVER_CERT
ARG SOLR_URL

# Labs specific
ARG LABS_GIT_WEBROOT
ARG LABS_DUMPS_WEBROOT
ARG LABS_DUMPS_LOCAL
ARG LABS_ROOT

# Fuseki
ARG FUSEKI_SERVER
ARG FUSEKI_STORAGE

# Indices
ARG JUDAICALINK_INDEX
ARG COMPACT_MEMORY_INDEX
ARG COMPACT_MEMORY_META_INDEX

# HCaptcha
ARG HCAPTCHA_SITEKEY

# Geonames
ARG GEONAMES_API_USER


# Set environment variables
ENV PYTHONPATH="/app:$PYTHONPATH"
ENV DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
ENV DJANGO_SUPERUSER_USERNAME=$DJANGO_SUPERUSER_USERNAME
ENV DJANGO_SUPERUSER_PASSWORD=$DJANGO_SUPERUSER_PASSWORD
ENV DJANGO_SUPERUSER_EMAIL=$DJANGO_SUPERUSER_EMAIL
ENV DATABASE_HOST=$DATABASE_HOST
ENV DATABASE_PORT=$DATABASE_PORT
ENV DATABASE_DB=$DATABASE_DB
ENV STATIC_URL=$STATIC_URL

ENV NVM_VERSION=22

# Generate a random secret key
RUN if [ -z "$SECRET_KEY" ];  \
    then echo "SECRET_KEY is not set. Generating a random one."; \
    # Generate a random secret key if not provided
    the SECRET_KEY=$(python -c "import secrets, string; alphabet = string.ascii_letters + string.digits + '@#$%&*-_=+'; print(''.join(secrets.choice(alphabet) for _ in range(50)))"); \
fi



# Write the agruments to the .env file
RUN echo "DEBUG=$DEBUG" >> .env && \
    echo "SECRET_KEY=$SECRET_KEY" >> .env && \
    echo "ALLOWED_HOSTS=$ALLOWED_HOSTS" >> .env && \
    echo "STATIC_URL=$STATIC_URL" >> .env && \
    echo "MEDIA_URL=$MEDIA_URL" >> .env && \
    echo "MEDIA_ROOT=$MEDIA_ROOT" >> .env && \
    echo "STATIC_ROOT=$STATIC_ROOT" >> .env && \
    echo "LOGFILE=$LOGFILE" >> .env && \
    echo "DATABASE_URL='$DATABASE_HOST://$DATABASE_USER:$DATABASE_PASSWORD@$DATABASE_HOST:$DATABASE_PORT/$DATABASE_DB'" >> .env && \
    echo "DATABASE_DB=$PDATABASE_DB" >> .env && \
    echo "DATABASE_USER=$DATABASE_USER" >> .env && \
    echo "DATABASE_PASSWORD=$DATABASE_PASSWORD" >> .env && \
    echo "DATABASE_HOST=$DATABASE_HOST" >> .env && \
    echo "DATABASE_PORT=$DATABASE_PORT" >> .env && \
    echo "REDIS_URL='redis://$REDIS_HOST:$REDIS_PORT/0'" >> .env && \
    echo "EMAIL_BACKEND='$EMAIL_BACKEND'" >> .env && \
    echo "EMAIL_HOST='$EMAIL_HOST'" >> .env && \
    echo "EMAIL_PORT=$EMAIL_PORT" >> .env && \
    echo "EMAIL_HOST_USER='$EMAIL_HOST_USER'" >> .env && \
    echo "EMAIL_HOST_PASSWORD='$EMAIL_HOST_PASSWORD'" >> .env && \
    echo "EMAIL_USE_TLS=$EMAIL_USE_TLS" >> .env && \
    echo "EMAIL_TO='$EMAIL_TO'" >> .env && \
    echo "DEFAULT_FROM_EMAIL='$DEFAULT_FROM_EMAIL'" >> .env && \
    echo "SOLR_SERVER='$SOLR_SERVER'" >> .env && \
    echo "SOLR_STORAGE='$SOLR_STORAGE'" >> .env && \
    echo "SOLR_CORE='$SOLR_CORE'" >> .env && \
    echo "SOLR_USER='$SOLR_USER'" >> .env && \
    echo "SOLR_PASSWORD='$SOLR_PASSWORD'" >> .env && \
    echo "SOLR_SERVER_CERT_PATH='$SOLR_SERVER_CERT_PATH'" >> .env && \
    echo "SOLR_SERVER_CERT='$SOLR_SERVER_CERT'" >> .env && \
    echo "SOLR_URL='$SOLR_URL'" >> .env && \
    echo "LABS_GIT_WEBROOT='$LABS_GIT_WEBROOT'" >> .env && \
    echo "LABS_DUMPS_WEBROOT='$LABS_DUMPS_WEBROOT'" >> .env && \
    echo "LABS_DUMPS_LOCAL='$LABS_DUMPS_LOCAL'" >> .env && \
    echo "LABS_ROOT='$LABS_ROOT'" >> .env && \
    echo "FUSEKI_SERVER='$FUSEKI_SERVER'" >> .env && \
    echo "FUSEKI_STORAGE='$FUSEKI_STORAGE'" >> .env && \
    echo "JUDAICALINK_INDEX='$JUDAICALINK_INDEX'" >> .env && \
    echo "COMPACT_MEMORY_INDEX='$COMPACT_MEMORY_INDEX'" >> .env && \
    echo "COMPACT_MEMORY_META_INDEX='$COMPACT_MEMORY_META_INDEX'" >> .env && \
    echo "HCAPTCHA_SITEKEY='$HCAPTCHA_SITEKEY'" >> .env && \
    echo "GEONAMES_API_USER='$GEONAMES'" >> .env

# Create logs directory
RUN mkdir -p /app/labs/logs && chmod -R 755 /app/labs/logs

WORKDIR /app
COPY . .
SHELL ["/bin/bash", "--login", "-c"]

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
RUN nvm install $NVM_VERSION

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

# Install Python dependencies
RUN pip install -r requirements.txt


WORKDIR /app/labs

# Delete node_modules and package-lock.json for a clean install
RUN rm -rf node_modules
RUN rm -rf package-lock.json
RUN rm -rf webpack-stats.json


# ENV für STATIC_URL, wenn dein webpack.config.js das nutzt (process.env.STATIC_URL)
ENV STATIC_URL=/labs/static/

RUN nvm use current
RUN npm install
RUN npm run build


# Wait for dependent services
COPY wait-for-it.sh /app/wait-for-it.sh
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/wait-for-it.sh /app/entrypoint.sh

WORKDIR /app

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["daphne", "--bind", "0.0.0.0", "-p", "8001", "labs.asgi:application"]

# Expose the port
EXPOSE 8001
