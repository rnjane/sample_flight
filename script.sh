#!/usr/bin/env bash

set -o errexit
set -o pipefail
# set -o nounset
# set -o xtrace

echo "---------------------------------------------"
echo "starting installs"
apt-get update
apt-get install -y python3-dev
apt-get install -y python3-setuptools
apt-get install -y libtiff5-dev libjpeg8-dev zlib1g-dev \
libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk
apt-get install -y software-properties-common
add-apt-repository -y ppa:chris-lea/redis-server
apt-get install -y redis-server
apt-get install -y python-virtualenv
apt-get install -y python3-pip
apt-get install -y git
apt-get clean

echo "----------------------------------------------"
echo "installs completed"


echo "----------------------------------------------"
echo "create code directory"
if [[ ! -d "code" ]];then
    mkdir -p ~/code
fi
cd ~/code

# echo "----------------------------------------------"
# echo "create and activate venv"
# if [[ ! -d "venv" ]];then
#     virtualenv -p python3 venv
# fi

# VENV_ROOT=venv/bin/activate
# source "${VENV_ROOT}"

echo "----------------------------------------------"
echo "clone the repo" 
if [[ ! -d "sample_flight" ]];then 
    git clone https://github.com/rnjane/sample_flight.git
fi

# Install requirements for the machine
pip3 install -r sample_flight/requirements.txt

cd ~/code/sample_flight

# Copy files
cp celeryd /etc/default/celeryd
cp init.d/celeryd /etc/init.d/celeryd
cp init.d/celerybeat /etc/init.d/celerybeat
chmod 755 /etc/init.d/celeryd
chmod 755 /etc/init.d/celeryd

echo "----------------------------------------------"
echo "run celery beat"
celery -A bookingapi beat -l info --detach

echo "----------------------------------------------"
echo "run celeryd"
celery -A bookingapi worker -l info --detach

echo "----------------------------------------------"
echo "run migrations"
python3 manage.py migrate --noinput

echo "----------------------------------------------"
echo "run the django server"
python3 manage.py runserver 0.0.0.0:8000