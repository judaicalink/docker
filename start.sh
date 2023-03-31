#!/bin/bash

service nginx start
service labs start
service pubby start
sleep 10s

/usr/share/fuseki/fuseki-server --update --loc /data/fuseki/databases/ --port 3030 /judaicalink &

sleep 10s
source /data/judaicalink/venv/bin/activate
python3 /data/judaicalink/judaicalink-loader/loader/loader.py

exit 0