#!/usr/bin/env bash

set -o errexit
set -o pipefail
# set -o nounset
# set -o xtrace

installation_1 () {
    sudo apt-get update
    sudo apt-get install -y - python3-dev
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository ppa:chris-lea/redis-server
    sudo apt-get install redis-server -y
    sudo apt-get install python-virtualenv
    sudo apt-get install -y python3-pip
    sudo apt-get install git
    sudo apt-get clean
}

# On the root of your virtual machine, create a folder healthcheckapp
pd# The folder is only created if it does not exist
if [[ ! -d "code" ]];then
    mkdir -p ~/code
fi
# Change directory from the root and into the healthcheck app
cd ~/code

if [[ ! -d "venv" ]];then
    virtualenv --python=python3 venv
fi

VENV_ROOT=venv/bin/activate
# Activate the virtual environment
source "${VENV_ROOT}"

if [[ ! -d "sampleflight" ]];then 
# Clone the repo into the virtual machine 
    git clone https://github.com/rnjane/sampleflight.git
fi

# Install requirements for the machine
pip install -r sampleflight/requirements.txt

cd ~/code/sampleflight

# Copy files
cp celeryd ~/etc/default/celeryd
cp init.d/celeryd ~/etc/init.d/celeryd
cp init.d/celerybeat ~/etc/init.d/celerybeat

# cp hc/local_settings.py.example hc/local_settings.py

# Run the migrate command
python ./manage.py migrate

# run the django server
python ./manage.py runserver 0.0.0.0:8000