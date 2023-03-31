#!/bin/bash
cd /data/judaicalink-labs/labs
source /data/judaicalink/venv/bin/activate
msg=`git pull`
if [[ "$msg" == "Already up to date." ]]; then
	echo "Nichts zu tun, Ende."
	exit 0
fi
sudo systemctl stop labs.service
pip3 install -r requirements.txt
python manage.py migrate --no-input
python manage.py collectstatic --no-input
sudo systemctl start labs.service
