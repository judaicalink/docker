# Base image with Python
FROM python:3.11-slim AS base

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
ARG GIT_REPO_URL
ARG GIT_BRANCH
RUN git config --global http.postBuffer 524288000 && \
    git config --global core.compression 0 && \
    git clone -b $GIT_BRANCH $GIT_REPO_URL /app/

# Move to the labs directory
WORKDIR /app/labs/

# Generate and populate the .env file
RUN python -c "import secrets, string; \
    alphabet = string.ascii_letters + string.digits + '!@#$%^&*-_+'; \
    print('SECRET_KEY=\"' + ''.join(secrets.choice(alphabet) for _ in range(50)) + '\"')" > .env

# Add additional environment variables
ARG DEBUG
ARG ALLOWED_HOSTS
ARG STATIC_URL
ARG MEDIA_URL
ARG MEDIA_ROOT
ARG STATIC_ROOT
ARG LOGFILE
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD
ARG POSTGRES_DB
ARG POSTGRES_HOST
ARG POSTGRES_PORT
RUN echo "DEBUG=$DEBUG" >> .env && \
    echo "ALLOWED_HOSTS=$ALLOWED_HOSTS" >> .env && \
    echo "STATIC_URL=$STATIC_URL" >> .env && \
    echo "MEDIA_URL=$MEDIA_URL" >> .env && \
    echo "MEDIA_ROOT=$MEDIA_ROOT" >> .env && \
    echo "STATIC_ROOT=$STATIC_ROOT" >> .env && \
    echo "LOGFILE=$LOGFILE" >> .env && \
    echo "DATABASE_URL=postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB" >> .env && \
    echo "DATABASE_DB=$POSTGRES_DB" >> .env && \
    echo "DATABASE_USER=$POSTGRES_USER" >> .env && \
    echo "DATABASE_PASSWORD=$POSTGRES_PASSWORD" >> .env && \
    echo "DATABASE_HOST=$POSTGRES_HOST" >> .env && \
    echo "DATABASE_PORT=$POSTGRES_PORT" >> .env


# Add the cache and Redis URLs to .env
ARG CACHE_URL
ARG REDIS_URL
ARG REDIS_HOST
ARG REDIS_PORT
ARG REDIS_PASSWORD
RUN echo "REDIS_URL='redis://$REDIS_HOST:$REDIS_PORT/0'" >> .env

# Add additional environment configurations \
# EMAIL
ARG EMAIL_BACKEND
ARG EMAIL_HOST
ARG EMAIL_PORT
ARG EMAIL_HOST_USER
ARG EMAIL_HOST_PASSWORD
ARG EMAIL_USE_TLS
ARG EMAIL_TO
ARG DEFAULT_FROM_EMAIL

RUN echo "EMAIL_BACKEND='$EMAIL_BACKEND'" >> .env
RUN echo "EMAIL_HOST='$EMAIL_HOST'" >> .env
RUN echo "EMAIL_PORT=$EMAIL_PORT" >> .env
RUN echo "EMAIL_HOST_USER='$EMAIL_HOST_USER'" >> .env
RUN echo "EMAIL_HOST_PASSWORD='$EMAIL_HOST_PASSWORD'" >> .env
RUN echo "EMAIL_USE_TLS=$EMAIL_USE_TLS" >> .env
RUN echo "EMAIL_TO='$EMAIL_TO'" >> .env
RUN echo "DEFAULT_FROM_EMAIL='$DEFAULT_FROM_EMAIL'" >> .env

# SOLR
ARG SOLR_SERVER
ARG SOLR_STORAGE
ARG SOLR_CORE
ARG SOLR_USER
ARG SOLR_PASSWORD
ARG SOLR_SERVER_CERT_PATH
ARG SOLR_SERVER_CERT
ARG SOLR_URL

RUN echo "SOLR_SERVER='$SOLR_SERVER'" >> .env
RUN echo "SOLR_STORAGE='$SOLR_STORAGE'" >> .env
RUN echo "SOLR_CORE='$SOLR_CORE'" >> .env
RUN echo "SOLR_USER='$SOLR_USER'" >> .env
RUN echo "SOLR_PASSWORD='$SOLR_PASSWORD'" >> .env
RUN echo "SOLR_SERVER_CERT_PATH='$SOLR_SERVER_CERT_PATH'" >> .env
RUN echo "SOLR_SERVER_CERT='$SOLR_SERVER_CERT'" >> .env
RUN echo "SOLR_URL='$SOLR_URL'" >> .env

# Labs
ARG LABS_GIT_WEBROOT
ARG LABS_DUMPS_WEBROOT
ARG LABS_DUMPS_LOCAL
ARG LABS_ROOT

RUN echo "LABS_GIT_WEBROOT='$LABS_GIT_WEBROOT'" >> .env
RUN echo "LABS_DUMPS_WEBROOT='$LABS_DUMPS_WEBROOT'" >> .env
RUN echo "LABS_DUMPS_LOCAL='$LABS_DUMPS_LOCAL'" >> .env
RUN echo "LABS_ROOT='$LABS_ROOT'" >> .env

# Fuseki
ARG FUSEKI_SERVER
ARG FUSEKI_STORAGE

RUN echo "FUSEKI_SERVER='$FUSEKI_SERVER'" >> .env
RUN echo "FUSEKI_STORAGE='$FUSEKI_STORAGE'" >> .env

# Indices
ARG JUDAICALINK_INDEX
ARG COMPACT_MEMORY_INDEX
ARG COMPACT_MEMORY_META_INDEX

RUN echo "JUDAICALINK_INDEX='$JUDAICALINK_INDEX'" >> .env
RUN echo "COMPACT_MEMORY_INDEX='$COMPACT_MEMORY_INDEX'" >> .env
RUN echo "COMPACT_MEMORY_META_INDEX='$COMPACT_MEMORY_META_INDEX'" >> .env


# HCaptcha
ARG HCAPTCHA_SITEKEY
RUN echo "HCAPTCHA_SITEKEY='$HCAPTCHA_SITEKEY'" >> .env

# Geonames
ARG GEONAMES_API_USER
RUN echo "GEONAMES_API_USER='$GEONAMES'" >> .env

# Create logs directory
RUN mkdir -p /app/labs/logs && chmod -R 755 /app/labs/logs

# Set environment variables
ENV PYTHONPATH="/app:$PYTHONPATH"
ENV DJANGO_SETTINGS_MODULE=labs.settings

WORKDIR /app
COPY . .
SHELL ["/bin/bash", "--login", "-c"]

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
RUN nvm install 22

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

# Install Python dependencies
RUN pip install -r requirements.txt
RUN echo $(ls -1 /app/labs)

WORKDIR /app/labs
RUN node -v
RUN nvm current
RUN npm -v

# Delete node_modules and package-lock.json for a clean install
RUN rm -rf node_modules
RUN rm -rf package-lock.json


# Install npm dependencies and build the frontend
RUN npm install
RUN npm run build
RUN npm run cs

# Collect static files
#RUN python manage.py collectstatic --no-input

# Wait for dependent services
COPY wait-for-it.sh /app/wait-for-it.sh
RUN chmod +x /app/wait-for-it.sh
#RUN /app/wait-for-it.sh $POSTGRES_HOST:$POSTGRES_PORT -- echo "Postgres is ready"


# Run the application using Daphne
CMD ["/bin/bash", "-c", "/app/wait-for-it.sh localhost:5434 -- python manage.py migrate && python manage.py collectstatic --no-input && daphne --bind 0.0.0.0 -p 8001 labs.asgi:application"]

#CMD ["daphne", "-b", "0.0.0.0", "-p", "8001", "labs.asgi:application"]

# Expose the port
EXPOSE 8001