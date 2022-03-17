#!/usr/bin/env bash

set -e

echo -e "Dumping environment variables for cron."
env >> /etc/environment

if [ "$XDEBUG_ENABLED" == "true" ]; then
    echo -e "[INFO] Enable xdebug."
  sed -i 's/^;zend/zend/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
else
    echo -e "[INFO] Disable xdebug."
  sed -i 's/^zend/;zend/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
fi

# Run crontab.
cron

exec "$@"
