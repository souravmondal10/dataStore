FROM ubuntu

MAINTAINER Sourav Mondal "souravmondal10@gmail.com"


WORKDIR /var/www/html

RUN apt-get update
RUN apt-get install -y php

#cron job to process the requests
RUN touch /var/log/cron.log
RUN (crontab -l ; echo "* * * * * php /var/www/html/storeData.php >> /var/log/cron.log") | crontab

COPY ./storeData.php ./storeData.php
COPY ./config.php ./config.php


