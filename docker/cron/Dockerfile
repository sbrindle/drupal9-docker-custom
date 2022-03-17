ARG DEFAULT_TAG=latest

FROM custom/php:${DEFAULT_TAG} as php
USER root

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
      cron && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add crontab file in the cron directory.
COPY crontab /etc/cron.d/drupal-cron

# Give execution rights on the cron job.
RUN chmod 0644 /etc/cron.d/drupal-cron && \
    \
# Create log file.
    touch /var/log/drupal-cron.log && \
    chown www-data:www-data /var/log/drupal-cron.log

# Set Entrypoint.
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["tail", "-F", "/var/log/drupal-cron.log"]
