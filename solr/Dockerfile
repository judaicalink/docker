FROM solr:latest


# Copy all core backups into the Solr data directory
COPY ./indices/ /var/solr/data/

USER root
# Change ownership to solr user
RUN chown -R solr:solr /var/solr/data

# Copy setup script into the container
COPY setup-cores.sh /scripts/setup-cores.sh
RUN chmod +x /scripts/setup-cores.sh

USER solr
RUN solr-precreate cm


#CMD ["sh", "-c", "/scripts/setup-cores.sh"]
# Start Solr and create cores
#CMD ["sh", "-c", "solr-precreate judaicalink && solr-precreate cm && solr-precreate cm_meta && solr-precreate cm_entities && solr-precreate cm_entitiy_names && solr-precreate judaicalink-beta && solr-foreground"]

#CMD ["sh", "-c", "/scripts/setup-cores.sh && solr-foreground"]
CMD ["solr-foreground"]