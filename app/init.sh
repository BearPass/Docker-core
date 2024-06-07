#!/bin/bash

set -e

echo "Initializing"

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

cd /var/www/bearpass

vendor_deps_status=$(composer install --no-dev --no-ansi --no-interaction --no-scripts --no-progress --prefer-dist --dry-run 2>&1)

if echo "$vendor_deps_status" | grep -q "Nothing to install, update or remove"; then
    echo "Vendor deps are up-to-date"
else
    echo "Downloading / updating vendor deps..."
        cd /var/www/bearpass && \
        composer install --no-dev -q --no-ansi --no-interaction --no-scripts --no-progress --prefer-dist && \
        composer dump-autoload
fi

if [ ! -f "/var/www/bearpass/.env" ]
then
    echo "Configuring, initialising / updating database..."
    cp .env.example .env && \
    php artisan key:generate && \
    php artisan encryption-key:generate && \
    php artisan migrate --seed --no-interaction --force && \
    php artisan optimize:clear
fi

chown -R $USERNAME:$GROUPNAME /var/www/bearpass

echo "Starting"

exec "$@"
