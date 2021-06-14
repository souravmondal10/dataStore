FROM php:7.4-fpm

MAINTAINER Sourav Mondal "souravmondal10@gmail.com"


WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis

COPY ./storeData.php ./storeData.php
COPY ./config.php ./config.php
RUN apt install -y crontab

RUN echo "* * * * * php /var/www/html/storeData.php >> /var/log/cron.log" >> /etc/crontab
RUN crontab /etc/crontab
RUN touch /var/log/cron.log
