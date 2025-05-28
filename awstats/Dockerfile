FROM pabra/awstats

COPY awstats_httpd.conf /usr/local/apache2/conf/awstats_httpd.conf

RUN echo "Include conf/awstats_httpd.conf" >> /usr/local/apache2/conf/httpd.conf
