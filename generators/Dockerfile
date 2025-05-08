# Use a lightweight base image with Git and Bash
FROM python:3.10-slim AS base

# Install Git and Bash
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    libpq-dev \
    gcc \
    curl \
    git \
    npm \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Define build arguments for the GitHub repository URL and branch
ARG GIT_REPO_URL=https://github.com/judaicalink/judaicalink-generators.git
ARG GIT_BRANCH=master
RUN git clone --branch $GIT_BRANCH $GIT_REPO_URL .

# Make all bash scripts executable
#RUN chmod +x *.sh

# Set the default command to bash, allowing you to run scripts interactively
CMD ["/bin/bash"]
