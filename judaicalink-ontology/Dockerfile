# Base image with Python and Node.js (for npm build step)
FROM python:3.10-slim AS base

# Install system dependencies
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

# Upgrade pip and configure pip settings for TLS/SSL
RUN python -m pip install --upgrade pip && \
    pip config set global.cert /etc/ssl/certs/ca-certificates.crt

# Set working directory
WORKDIR /app

# Define build arguments for the GitHub repository URL and branch
ARG GIT_REPO_URL=https://github.com/judaicalink/judaicalink-ontology.git
ARG GIT_BRANCH=master
ARG FUSEKI_SERVER
ARG FUSEKI_USER
ARG FUSEKI_PASSWORD

ENV FUSEKI_SERVER=$FUSEKI_SERVER
ENV FUSEKI_USER=$FUSEKI_USER
ENV FUSEKI_PASSWORD=$FUSEKI_PASSWORD


# Clone the specified branch of the repository
RUN git clone -b $GIT_BRANCH $GIT_REPO_URL .

# Make all bash scripts executable
# RUN chmod +x *.sh

# Set the default command to bash, allowing you to run scripts interactively
CMD ["/bin/bash"]
SHELL ["/bin/bash", "-c"]

# Install Python dependencies
RUN python -m pip install --upgrade pip

RUN echo "Generating the ontology"


RUN python generate.py

# copy run.sh
COPY run.sh /app/run.sh

# Make the run.sh executable
RUN chmod +x /app/run.sh

# Run the run.sh script
RUN /app/run.sh

# Run the script as the main container process
ENTRYPOINT ["/app/run.sh"]

CMD ["tail", "-f", "/dev/null"]

