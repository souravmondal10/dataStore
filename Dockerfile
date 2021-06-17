FROM php:7.4-fpm

MAINTAINER Sourav Mondal "souravmondal10@gmail.com"


WORKDIR /var/www/html

RUN apt update && apt install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        cron \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis

#cron job to process the requests
RUN touch /var/log/cron.log
RUN (crontab -l ; echo "* * * * * php /var/www/html/storeData.php >> /var/log/cron.log") | crontab

COPY ./storeData.php ./storeData.php
COPY ./config.php ./config.php


