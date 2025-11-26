# Use a lightweight base image with Git and Bash
FROM python:3.12-slim

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

ARG FUSEKI_SERVER
ENV JL_FUSEKI_URL=${FUSEKI_SERVER}/judaicalink


RUN git clone --branch $GIT_BRANCH $GIT_REPO_URL .
RUN pip install --no-cache-dir -r requirements.txt

COPY run.sh /app/run.sh

RUN chmod +x run.sh

# Set the default command to bash, allowing you to run scripts interactively
ENTRYPOINT ["bash", "run.sh"]

#CMD ["tail", "-f", "/dev/null"]