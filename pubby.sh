#!/bin/bash
### BEGIN INIT INFO
# Provides:       labs
# Required-Start:    $local_fs $remote_fs $network $syslog $named
# Required-Stop:     $local_fs $remote_fs $network $syslog $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the labs web server
# Description:       starts labs using start-stop-daemon
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin


start() {
    echo "Starting pubby service..."
    source /data/judaicalink/venv/bin/activate
    cd /data/judaicalink/pubby-django
    ./runserver.sh start
}

stop() {
    echo "Stopping pubby service..."
    cd /data/judaicalink/pubby-django
    ./runserver.sh stop
}

case "$1" in
    start)
       start
       ;;
    stop)
       stop
       ;;
    restart)
       stop
       start
       ;;
    status)
       # code to check status of app comes here
       # example: status program_name
       ;;
    *)
       echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0