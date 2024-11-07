# Base image with Python and Node.js (for npm build step)
FROM python:3.10-slim AS base

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
#    ca-certificates \
    build-essential \
    libpq-dev \
    gcc \
    curl \
    git \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and configure pip settings for TLS/SSL
RUN python -m pip install --upgrade pip && \
    pip config set global.cert /etc/ssl/certs/ca-certificates.crt

# Set working directory
WORKDIR /app

# Clone the deployment branch of the repository
ARG GIT_REPO_URL
ARG GIT_BRANCH=solr
RUN git clone --branch $GIT_BRANCH $GIT_REPO_URL .

WORKDIR /app/labs

# Generate a random SECRET_KEY and write it to .env
RUN python -c "import secrets, string; alphabet = string.ascii_letters + string.digits + '!@#$%^&*-_+'; print('SECRET_KEY=\"' + ''.join(secrets.choice(alphabet) for _ in range(50)) + '\"')" > .env
RUN echo 'DEBUG=False' >> .env
RUN echo 'ALLOWED_HOSTS=localhost,127.0.0.1' >> .env
RUN echo 'STATIC_URL=/static/' >> .env
RUN echo 'MEDIA_URL=/media/' >> .env
RUN echo 'MEDIA_ROOT=media/' >> .env
RUN echo 'STATIC_ROOT=static/' >> .env
RUN echo 'LOGFILE=django.log' >> .env

# Configure DATABASE_URL with the service name `postgres` for Docker DNS resolution
RUN echo "DATABASE_URL='postgres://judaicalink:xO@X67B7J2Nq1bGYozCG@postgres:5432/judicalink-labs-db'" >> .env

# Configure CACHE_URL and REDIS_URL to use `redis` service name instead of localhost
RUN echo "CACHE_URL='redis://redis:6379/1'" >> .env
RUN echo "REDIS_URL='redis://redis:6379/0'" >> .env

# Add additional environment configurations
# Email
RUN echo "EMAIL_BACKEND='django.core.mail.backends.console.EmailBackend'" >> .env
RUN echo "EMAIL_HOST='mailserver'" >> .env
RUN echo "EMAIL_PORT=25" >> .env
RUN echo "EMAIL_HOST_USER='judaicalink'" >> .env
RUN echo "EMAIL_HOST_PASSWORD='dummy'" >> .env
RUN echo "EMAIL_USE_TLS=False" >> .env
RUN echo "EMAIL_TO='b.schnabel@hs-mannheim.de'" >> .env
RUN echo "DEFAULT_FROM_EMAIL='info@judaicalink.org'" >> .env

# SOLR
RUN echo "SOLR_SERVER='http://solr:8983/'" >> .env
RUN echo "SOLR_STORAGE='/var/lib/solr'" >> .env
RUN echo "SOLR_CORE='judaicalink'" >> .env
RUN echo "SOLR_USER='solr'" >> .env
RUN echo "SOLR_PASSWORD=''" >> .env
RUN echo "SOLR_SERVER_CERT_PATH=''" >> .env
RUN echo "SOLR_SERVER_CERT=''" >> .env
RUN echo "SOLR_URL='https://localhost:8983/solr/'" >> .env

# Labs
RUN echo "LABS_GIT_WEBROOT=''" >> .env
RUN echo "LABS_DUMPS_WEBROOT=''" >> .env
RUN echo "LABS_DUMPS_LOCAL=''" >> .env
RUN echo "LABS_ROOT='http://localhost:8000'" >> .env

# Fuseki
RUN echo "FUSEKI_SERVER='https://localhost:3030/'" >> .env
RUN echo "FUSEKI_STORAGE='.'" >> .env

# Indices
RUN echo "JUDAICALINK_INDEX='judaicalink'" >> .env
RUN echo "COMPACT_MEMORY_INDEX='cm'" >> .env
RUN echo "COMPACT_MEMORY_META_INDEX='cm_meta'" >> .env

# HCaptcha
RUN echo "HCAPTCHA_SITEKEY=''" >> .env
RUN echo "HCAPTCHA_SECRET=''" >> .env

# Geonames
RUN echo "GEONAMES_API_USER=''" >> .env

# Move to /app and install dependencies
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt

# Move to labs directory for npm build
WORKDIR /app/labs

RUN npm install -g npm@latest


RUN npm cache clean --force && npm install

#RUN npm install
RUN npm run build

# Copy wait-for-it script to wait for dependent services
COPY wait-for-it.sh /app/
RUN chmod +x /app/wait-for-it.sh

# Wait for the database
RUN /app/wait-for-it.sh postgres:5432 -- echo "Postgres is ready"

# Run migrations
RUN python manage.py migrate

# Collect static files
RUN python manage.py collectstatic --no-input

# Set CMD to start Daphne
CMD ["daphne", "--bind", "0.0.0.0", "-p", "8000", "labs.asgi:application"]

# Expose the app port
EXPOSE 8000
