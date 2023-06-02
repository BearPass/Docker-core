#!/bin/bash

USERNAME="www-data"
GROUPNAME="www-data"

LUID=${USER_ID:-0}
LGID=${GROUP_ID:-0}

if [ $LUID -eq 0 ]; then
    LUID=65534
fi

if [ $LGID -eq 0 ]; then
    LGID=65534
fi

groupadd -o -g $LGID $GROUPNAME >/dev/null 2>&1 ||
groupmod -o -g $LGID $GROUPNAME >/dev/null 2>&1
useradd -o -u $LUID -g $GROUPNAME -s /bin/false $USERNAME >/dev/null 2>&1 ||
usermod -o -u $LUID -g $GROUPNAME -s /bin/false $USERNAME >/dev/null 2>&1
mkhomedir_helper $USERNAME

mkdir -p /var/www/bearpass

if [ ! -d "/var/www/bearpass/vendor" ]
then
    cd /var/www/bearpass && \
    composer install --no-dev -q --no-ansi --no-interaction --no-scripts --no-progress --prefer-dist && \
    composer dump-autoload
fi

if [ ! -f "/var/www/bearpass/.env" ]
then
    cd /var/www/bearpass && \
    cp .env.example .env && \
    php artisan key:generate && \
    php artisan encryption-key:generate && \
    php artisan migrate --seed --no-interaction --force && \
    php artisan optimize:clear
fi

chown -R $USERNAME:$GROUPNAME /var/www/bearpass

exec "$@"
