#!/bin/bash

PROJECT_ENVIRONMENT=${PROJECT_ENVIRONMENT:-prod}
CACHE_STATIC_EXPIRES=${CACHE_STATIC_EXPIRES:-max}
CACHE_STATIC_RULE=${CACHE_STATIC_RULE:-"max=10000 inactive=1h"}

#----------------------------------------
# Replace environment variables.
# Note: URLs are "sed"-ed with the tild delimiter to avoid having to escape the slash that compose them.
#----------------------------------------
sed -i "s~<ENDPOINT_PHP>~${ENDPOINT_PHP}~" /etc/nginx/snippets/drupal.conf
sed -i "s~<ENDPOINT_PHP>~${ENDPOINT_PHP}~" /etc/nginx/snippets/php-fpm-status.conf
sed -i "s~<CACHE_STATIC_EXPIRES>~${CACHE_STATIC_EXPIRES}~" /etc/nginx/snippets/drupal.conf
sed -i "s~<CACHE_STATIC_RULE>~${CACHE_STATIC_RULE}~" /etc/nginx/snippets/drupal.conf
sed -i "s~<IDP_BASE_URL>~${IDP_BASE_URL}~" /etc/nginx/snippets/cors.conf

if [ "$PROJECT_ENVIRONMENT" == "local" ]; then
  echo "Use Drupal with HTTPS."
  rm /etc/nginx/conf.d/cms.conf

  sed -i "s~<PROJECT_BASE_URL>~${PROJECT_BASE_URL}~" /etc/nginx/conf.d/cms-https.conf
  sed -i "s~<PROJECT_ADMIN_URL>~${PROJECT_ADMIN_URL}~" /etc/nginx/conf.d/cms-https.conf
  sed -i "s~<PROJECT_MAIL_URL>~${PROJECT_MAIL_URL}~" /etc/nginx/conf.d/mail-https.conf
else
  echo "Use Drupal in HTTP."
  rm /etc/nginx/conf.d/cms-https.conf
  rm /etc/nginx/conf.d/mail-https.conf

  sed -i "s~<PROJECT_BASE_URL>~${PROJECT_BASE_URL}~" /etc/nginx/conf.d/cms.conf
  sed -i "s~<PROJECT_ADMIN_URL>~${PROJECT_ADMIN_URL}~" /etc/nginx/conf.d/cms.conf
fi

exec "$@"
