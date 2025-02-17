FROM solr:latest

USER root

# Copy custom config set into the container
COPY config /opt/solr/server/solr/configsets/myconfig

# Set proper ownership for Solr
RUN chown -R solr:solr /opt/solr/server/solr/configsets

USER solr

# Create cores with the copied configset
RUN solr create_core -c cm -d /opt/solr/server/solr/myconfig && \
    solr create_core -c cm_meta -d /opt/solr/server/solr/myconfig && \
    solr create_core -c cm_entities -d /opt/solr/server/solr/myconfig && \
    solr create_core -c cm_entitiy_names -d /opt/solr/server/solr/myconfig && \
    solr create_core -c judaicalink -d /opt/solr/server/solr/myconfig && \
    solr create_core -c judaicalink-beta -d /opt/solr/server/solr/myconfig

EXPOSE 8983

CMD ["solr-foreground"]
