#!/bin/bash

# Immediately exit if any command being run exits with a non-zero exit code
set -e

if [ "$XDEBUG_ENABLED" == "true" ]; then
    echo -e "[INFO] Enable xdebug."
  sed -i 's/^;zend/zend/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug3.ini
else
    echo -e "[INFO] Disable xdebug."
  sed -i 's/^zend/;zend/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug3.ini
fi

exec "$@"
