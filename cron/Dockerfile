FROM php:8.2-cli-alpine
MAINTAINER info@bearpass.ru

RUN set -ex && \
    apk --no-cache --update add \
        libxml2-dev \
        oniguruma-dev \
        libpng \
        libjpeg-turbo \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        libzip-dev \
        curl-dev \
        icu-dev \
        postgresql-dev \
        ldb-dev \
        libldap \
        openldap-dev \
        bash

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg && \
    docker-php-ext-install \
    curl \
    intl \
    mbstring \
    pdo \
    pdo_pgsql \
    zip \
    xml \
    ldap \
    bcmath

COPY ./conf/cron/crontab /var/spool/cron/crontabs/www-data
COPY ./conf/php/php.ini $PHP_INI_DIR/

COPY ./init.sh /usr/bin/init
RUN chmod +x /usr/bin/init

RUN apk add shadow

CMD ["init"]