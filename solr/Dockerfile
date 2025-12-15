# Use the official Solr image
FROM solr:latest

# Copy custom schema and configuration into the container
#COPY solr-config /opt/solr/server/solr/configsets

# Create dir /var/solr/data
#RUN mkdir -p /var/solr/data

# Copy the initialization script
COPY solr-init.sh /docker-entrypoint-initdb.d/solr-init.sh
USER root
RUN chmod +x /docker-entrypoint-initdb.d/solr-init.sh

RUN chown -R solr:solr /app

RUN apt-get update \
 && apt-get install -y --no-install-recommends lbzip2 \
 && rm -rf /var/lib/apt/lists/*

#RUN /docker-entrypoint-initdb.d/docker-entrypoint.sh

USER solr

WORKDIR /app
COPY indices2.tar.bz2 /app/indices2.tar.bz2
