#!/usr/bin/env sh
set -e

mkdir -p /var/www/html/uploads
chmod 777 /var/www/html/uploads || true

exec "$@"
