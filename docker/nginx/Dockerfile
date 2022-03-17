ARG DEFAULT_TAG=latest
ARG REGISTRY_PATH_PREFIX=snapshots

FROM custom/php:${DEFAULT_TAG} as php
FROM nginx:1.19.10 as nginx

# Update packages.
RUN apt-get update && \
    apt-get -y upgrade && \
    rm -rf /var/lib/apt/lists/*

# Remove default NGINX configuration.
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy NGINX configurations.
COPY certs /etc/ssl/certs
COPY conf/* /etc/nginx/conf.d/
COPY snippets /etc/nginx/snippets
COPY vhosts/* /etc/nginx/conf.d/

# Copy sources for NGINX configuration files.
COPY --from=php --chown=www-data:www-data /var/www/html/web  /var/www/html/web

# Set Entrypoint.
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
