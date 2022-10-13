#!/bin/bash
start() {
	cd /data/judaicalink/pubby-django/server
	source /data/judaicalink/venv/bin/activate
        nohup gunicorn -b 'localhost:8001' server.wsgi |& tee -a /var/log/pubby.log &
        _pid=$!
        echo "$_pid" > /var/run/judaicalink-pubby.pid
}
stop() {
        _pid=`cat /var/run/judaicalink-pubby.pid`
        kill -3 $_pid
	rm /var/run/judaicalink-pubby.pid
}
case $1 in
        start|stop) "$1";;
 esac