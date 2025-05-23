"""
Django settings for this project.

Copy this file to localsettings.py and adjust it.
You can overwrite all settings here.

This is used for deployment settings and can be used
for local development as well.

The localsettings.py is never added to git.
"""

SECRET_KEY = 'as;ldkjf3e8u3jasd;lkfja8er3ukl;asjdf;lkjase3e8'
DEBUG = False
DJANGO_LOG_FILE = "/var/log/pubby.log"
DJANGO_LOG_LEVEL = "INFO"

ALLOWED_HOSTS = ['localhost', '127.0.0.1', 'data.judaicalink.org']
# The path where the static files are copied on the server
STATIC_URL = '/static/'
STATIC_ROOT = '/data/data.judaicalink.org/htdocs/static/'
PUBBY_CONFIG = {
       "pubby": "pubby/config.ttl",
       "pubby2": "pubby/config-local.ttl",
       "data":  "pubby/config-judaicalink.ttl",
       "datasets":  "pubby/config-judaicalink-datasets.ttl",
       "ontology":  "pubby/config-judaicalink-ontology.ttl",
        }
USE_X_FORWARDED_HOST = True
USE_X_FORWARDED_PORT = True

GND_FILE = "/data/data.judaicalink.org/htdocs/dumps/ep/ep_GND_ids.json.gz"

DATASETS_DIR="/data/web.judaicalink.org/judaicalink-site/content/datasets"
