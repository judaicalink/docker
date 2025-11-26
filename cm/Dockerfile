FROM python:3.12-slim

# Install wget, git, etc. if needed
RUN apt-get update && apt-get install -y wget git bash && rm -rf /var/lib/apt/lists/*

ARG CM_DATA_DIR
ENV CM_DATA_DIR=${CM_DATA_DIR:-/data}

# Create directories
RUN mkdir -p /app/cm

# Set workdir
WORKDIR /app

# Copy run script into container
COPY run.sh /app/run.sh

# Make the script executable
RUN chmod +x /app/run.sh

# Default command
ENTRYPOINT ["/app/run.sh"]
