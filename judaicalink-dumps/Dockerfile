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

RUN pip install requests beautifulsoup4 python-dotenv


# Set the default command to bash, allowing you to run scripts interactively
CMD ["/bin/bash"]

COPY .env /app/.env

#  Downloads the dumps from the server for now.
COPY download_dumps.py /app/download_dumps.py

#COPY /app /data/dumps
COPY copy_script.sh /app/copy_script.sh
RUN chmod +x /app/copy_script.sh
ENTRYPOINT ["/app/copy_script.sh"]
