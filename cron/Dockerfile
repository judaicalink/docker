FROM python:3.11-slim

WORKDIR /app

RUN apt-get update --yes --quiet && \
    apt-get install --yes --no-install-recommends \
        cron \
        logrotate \
        rsync \
        mailutils \
        gzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./cron/backup_solr_indices.py /app/scripts/
COPY ./cron/backup_fuseki.sh /app/scripts/
COPY ./cron/backup_triples.sh /app/scripts/
COPY ./cron/restore_backup.sh /app/scripts/
COPY ./cron/email_on_failure.sh /app/scripts/
COPY ./cron/crontab /etc/cron.d/judaicalink-cron
COPY ./cron/logrotate.conf /etc/logrotate.d/judaicalink

RUN chmod 0644 /etc/cron.d/judaicalink-cron && crontab /etc/cron.d/judaicalink-cron
RUN chmod +x /app/scripts/*.sh

ENV SAMBA_BACKUP_DIR=/mnt/samba \
    SOLR_URL=http://solr:8983/solr \
    FUSEKI_DATA=/fuseki/data \
    TRIPLES_DIR=/data/dumps \
    BACKUP_RETENTION_DAYS=90 \
    ADMIN_EMAIL=admin@example.org

CMD ["cron", "-f"]
