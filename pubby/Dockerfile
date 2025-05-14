###################################
# Dockerfile for Pubby-Django
##################################

# Use a Python base image
FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 ca-certificates && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138 112695A0E562B32A


# Install required system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    libpq-dev \
    gcc \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and configure pip settings for TLS/SSL
RUN python -m pip install --upgrade pip && \
    pip config set global.cert /etc/ssl/certs/ca-certificates.crt


# Set working directory
WORKDIR /app

# Define build arguments
ARG GIT_REPO_URL=https://github.com/judaicalink/pubby-django
ARG GIT_BRANCH=master

# Clone the repository using the specified branch
RUN git clone -b $GIT_BRANCH $GIT_REPO_URL .

# Fetch the latest release tag and clone
#RUN LATEST_TAG=$(curl -s https://api.github.com/repos/GIT_REPO_URL/releases/latest | grep tag_name | cut -d '"' -f 4) && \
#    git clone --depth 1 --branch $LATEST_TAG https://github.com/GIT_REPO_URL.git . && \
#    echo "Cloned latest release: $LATEST_TAG"

# Install Python dependencies, including gunicorn
RUN pip install -r requirements.txt
# In case you want to install development dependencies, uncomment the line below
#RUN pip install -r requirements-dev.txt

WORKDIR /app/server/server

# Set the settings
ARG DJANGO_SETTINGS_MODULE=server.settings
ARG SECRET_KEY
ARG DEBUG=False
ARG ALLOWED_HOSTS
ARG STATIC_URL
ARG STATIC_ROOT
ARG MEDIA_URL
ARG MEDIA_ROOT
ARG LOGFILE
ARG GND_FILE
ARG GITHUB_TOKEN
ARG GITHUB_REPO
ARG DATABASE_URL
ARG DATABASE_ENGINE
ARG DATABASE_NAME

#RUN python -c "import secrets, string; alphabet = string.ascii_letters + string.digits + '@#$%&*-_=+'; print('SECRET_KEY=\"' + ''.join(secrets.choice(alphabet) for _ in range(50)) + '\"')" >> localsettings.py

RUN echo "DEBUG=$DEBUG" >> localsettings.py && \
    echo "SECRET_KEY='$SECRET_KEY'" >> localsettings.py && \
    echo "ALLOWED_HOSTS=$ALLOWED_HOSTS" >> localsettings.py && \
    echo "STATIC_URL='$STATIC_URL'" >> localsettings.py && \
    echo "MEDIA_URL='$MEDIA_URL'" >> localsettings.py && \
    echo "MEDIA_ROOT='$MEDIA_ROOT'" >> localsettings.py && \
    echo "STATIC_ROOT='$STATIC_ROOT'" >> localsettings.py && \
    echo "LOGFILE='$LOGFILE'" >> localsettings.py && \
    echo "GND_FILE='$GND_FILE'" >> localsettings.py && \
    echo "GITHUB_TOKEN='$GITHUB_TOKEN'" >> localsettings.py && \
    echo "GITHUB_REPO='$GITHUB_REPO'" >> localsettings.py && \
    echo "DATABASE_URL='$DATABASE_URL'" >> localsettings.py && \
    echo "DATABASE_ENGINE='$DATABASE_ENGINE'" >> localsettings.py && \
    echo "DATABASE_NAME='$DATABASE_NAME'" >> localsettings.py

WORKDIR /app

# Copy wait-for-it script and make it executable
COPY wait-for-it.sh /app/
RUN chmod +x /app/wait-for-it.sh

WORKDIR /app/server

# Run the wait-for-it script before starting the app with gunicorn
CMD ["/bin/bash", "-c", "/app/wait-for-it.sh postgres:5432 -- python manage.py migrate && python manage.py collectstatic --no-input && gunicorn --bind 0.0.0.0:8000 server.wsgi:application"]

# Expose the port on which the app will run
EXPOSE 8000