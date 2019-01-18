#!/usr/bin/env bash

set -o errexit
set -o pipefail

redis-server --daemonize yes
celery -A bookingapi beat -l info --detach
celery -A bookingapi worker -l info --detach
python3 manage.py runserver 0.0.0.0:8000