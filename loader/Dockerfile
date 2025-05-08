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

# install packages
RUN pip install toml pyyaml rdflib hugo sparqlwrapper

# Set working directory
WORKDIR /app

# Define build arguments for the GitHub repository URL and branch
ARG GIT_REPO_URL=https://github.com/judaicalink/judaicalink-loader.git
ARG GIT_BRANCH=master

# Clone the specified branch of the repository
RUN git clone -b $GIT_BRANCH $GIT_REPO_URL .

WORKDIR /app/loader

# Set the environment variable

# Set the default command to bash, allowing you to run scripts interactively
CMD ["/bin/bash"]

# loads the data, but takes a while
ENTRYPOINT ["python", "loader.py"]