#!/bin/sh

set -e

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

if grep -q "^${USERNAME}:" /etc/passwd; then
    deluser "$USERNAME" 2>/dev/null || true
fi

if grep -q "^${GROUPNAME}:" /etc/group; then
    delgroup "$GROUPNAME" 2>/dev/null || true
fi

addgroup -g "$LGID" "$GROUPNAME"

adduser -u "$LUID" -D -S -G "$GROUPNAME" "$USERNAME"

exec "$@"
