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

#RUN /docker-entrypoint-initdb.d/docker-entrypoint.sh

USER solr

WORKDIR /app
COPY indices/data.json /data.json

RUN echo "Starting Solr in foreground mode"
# Start Solr in foreground mode
#CMD ["solr", "start", "-f"]
RUN solr start -f

# Expose the default Solr port
EXPOSE 8983

#RUN echo "Waiting for Solr to start..."
#RUN timeout 60 bash -c 'until curl -s http://localhost:8983/solr/; do sleep 5; done'


RUN echo "Loading JSON data into cores..."
RUN curl -X POST -H "Content-Type: application/json" \
     --data-binary @/data.json \
     "http://localhost:8983/solr/judaicalink/update?commit=true"

RUN curl -X POST -H "Content-Type: application/json" \
     --data-binary @/data.json \
     "http://localhost:8983/solr/cm/update?commit=true"


