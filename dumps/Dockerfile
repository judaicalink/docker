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

ARG BASE_URL
ARG DUMPS_SAVE_DIR
ARG DUMPS_COPY_DIR

ENV BASE_URL=$BASE_URL
ENV SAVE_DIR=${DUMPS_SAVE_DIR:-/app/downloads}
ENV COPY_DIR=${DUMPS_COPY_DIR:-/data/dumps}

# Upgrade pip and configure pip for TLS/SSL
RUN python -m pip install --upgrade pip

# Set working directory
WORKDIR /app

RUN pip install requests beautifulsoup4 python-dotenv


# Set the default command to bash, allowing you to run scripts interactively
CMD ["/bin/bash"]


RUN echo "BASE_URL=$BASE_URL" >> /app/.env && \
    echo "SAVE_DIR=$SAVE_DIR" >> /app/.env && \
    echo "COPY_DIR=$COPY_DIR" >> /app/.env

#  Downloads the dumps from the server for now.
COPY downloader.py /app/downloader.py


ENTRYPOINT ["python", "/app/downloader.py"]
