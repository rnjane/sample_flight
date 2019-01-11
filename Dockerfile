FROM ubuntu:16.04
LABEL maintainer="Robert Njane <robert.njane@andela.com>"

RUN apt-get update && apt-get install -y python3-pip python-dev && apt-get clean
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:chris-lea/redis-server && apt-get update && apt-get install redis-server -y

ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
RUN useradd celery && usermod -a -G celery celery
ADD requirements.txt /code/
RUN pip3 install -r requirements.txt
ADD . /code/
COPY ./celeryd /etc/default/celeryd
COPY ./init.d/celeryd /etc/init.d/celeryd
COPY ./init.d/celerybeat /etc/init.d/celerybeat
RUN celery -A bookingapi worker -l info --detach
RUN celery -A bookingapi beat -l info --detach 
RUN python3 /code/manage.py migrate --noinput && python3 /code/manage.py runserver 0.0.0.0:8000