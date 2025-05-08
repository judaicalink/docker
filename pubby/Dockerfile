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


WORKDIR /app/server/server

# Set the settings
RUN python -c "import secrets, string; alphabet = string.ascii_letters + string.digits + '@#$%&*-_=+'; print('SECRET_KEY=\"' + ''.join(secrets.choice(alphabet) for _ in range(50)) + '\"')" >> localsettings.py
RUN echo 'DEBUG=True' >> localsettings.py
RUN echo "ALLOWED_HOSTS=['localhost', '127.0.0.1']" >> localsettings.py
RUN echo 'STATIC_URL="/static/"' >> localsettings.py
RUN echo 'MEDIA_URL="/media/"' >> localsettings.py
RUN echo 'MEDIA_ROOT="media/"' >> localsettings.py
RUN echo 'STATIC_ROOT="static/"' >> localsettings.py
RUN echo 'LOGFILE="django.log"' >> localsettings.py
RUN echo 'GND_FILE="./pubby/ep_GND_ids.json.gz"' >> localsettings.py
RUN echo 'GITHUB_TOKEN=""' >> localsettings.py
RUN echo 'GITHUB_REPO=""' >> localsettings.py


WORKDIR /app

# Copy wait-for-it script and make it executable
COPY wait-for-it.sh /app/
RUN chmod +x /app/wait-for-it.sh

# Install Python dependencies, including gunicorn
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app/server


# Run the wait-for-it script before starting the app with gunicorn
CMD ["/bin/bash", "-c", "/app/wait-for-it.sh postgres:5432 -- python manage.py migrate && python manage.py collectstatic --no-input && gunicorn --bind 0.0.0.0:8000 server.wsgi:application"]

# Expose the port on which the app will run
EXPOSE 8000