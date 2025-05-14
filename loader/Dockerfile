# Use a lightweight base image with Git and Bash
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

# Define build arguments for the GitHub repository URL and branch
ARG GIT_REPO_URL=https://github.com/judaicalink/judaicalink-loader.git
ARG GIT_BRANCH=master

# Clone the specified branch of the repository
RUN git clone -b $GIT_BRANCH $GIT_REPO_URL .

# install packages
RUN pip install -r requirements.txt

ARG FUSEKI_SERVER=http://fuseki:3030/
ENV ENDPOINT=${FUSEKI_SERVER}judaicalink

ARG FUSEKI_SERVER
ARG FUSEKI_USER
ARG FUSEKI_PASSWORD

ENV FUSEKI_SERVER=$FUSEKI_SERVER
ENV FUSEKI_USER=$FUSEKI_USER
ENV FUSEKI_PASSWORD=$FUSEKI_PASSWORD


# Copy the run script
COPY run.sh /app/run.sh

# Run script
RUN chmod +x /app/run.sh

ENTRYPOINT ["/app/run.sh"]