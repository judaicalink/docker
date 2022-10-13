#!/bin/bash
cd /data/judaicalink/pubby-django/server
source /data/judaicalink/venv/bin/activate
msg=`git pull`
if [[ "$msg" == "Already up to date." ]]; then
        echo "Nichts zu tun, Ende."
        exit 0
fi
sudo systemctl stop pubby.service
sudo pip3 install -r ../requirements.txt
sudo python3 manage.py migrate --no-input
sudo python3 manage.py collectstatic --no-input
sudo systemctl start pubby.service