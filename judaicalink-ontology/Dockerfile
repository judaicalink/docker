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

# Clone the specified branch of the repository
RUN git clone -b $GIT_BRANCH $GIT_REPO_URL .

# Make all bash scripts executable
# RUN chmod +x *.sh

# Set the default command to bash, allowing you to run scripts interactively
CMD ["/bin/bash"]

# Install Python dependencies
RUN python -m pip install --upgrade pip

RUN python generate.py


# FIXME: Create a new dataset in the triplestore
CMD curl -u admin:Jbz7DWU1K15YGqh -X POST http://fuseki:3030/$/datasets \
  -d "dbName=judaicalink" \
  -d "dbType=tdb2"

CMD curl -u admin:Jbz7DWU1K15YGqh http://fuseki:3030/$/datasets

# FIXME: Create a new graph in the triplestore
CMD curl -X PUT -H "Content-Type: text/turtle" \
    -u admin:Jbz7DWU1K15YGqh \
     http://fuseki:3030/judaicalink/data?graph=http://judaicalink.org/ontology

#RUN curl --request POST -sL \
#    --data-binary '@./create-dataset.sparql'    --header 'Content-Type: application/sparql-query' \
#    --url 'http://localhost:3030/judaicalink/update'

# FIXME: Load the ttl file into the triplestore
CMD curl  --request POST -sL \
    -u admin:Jbz7DWU1K15YGqh \
    --data-binary '@./judaicalink-ontology.ttl'    --header 'Content-Type: text/x-turtle' \
    --url 'http://fuseki:3030/judaicalink/data'

EXPOSE 80
