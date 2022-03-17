FROM composer:2.0.14 AS composer
FROM php:8.1-fpm AS php-fpm

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV TZ Europe/Paris
ENV PS1="\w \\$ "

ARG MYSQL_GPG_KEY=467B942D3A79BD29

RUN echo "set mouse-=a" >> /var/www/.vimrc && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends \
      git \
      gnupg2 \
      libbz2-dev \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      libpcre3-dev \
      libxml2-dev \
      libxslt1-dev \
      libzip-dev \
      jpegoptim \
      optipng \
      unzip \
      vim \
      wget && \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $MYSQL_GPG_KEY && \
    gpg --batch --export $MYSQL_GPG_KEY > /etc/apt/trusted.gpg.d/mysql.gpg  && \
    gpgconf --kill all && \
    echo "deb http://repo.mysql.com/apt/debian/ buster mysql-8.0" > /etc/apt/sources.list.d/mysql.list && \
    apt-get update && \
    apt-get -y install --no-install-recommends mysql-community-client && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && apt-get autoremove -y

# Install php extensions.
RUN docker-php-ext-install -j$(nproc) \
    bcmath \
    bz2 \
    exif \
    intl \
    opcache \
    pdo_mysql \
    soap \
    sockets \
    xsl \
    zip

# Install GD.
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd

# Set the SHELL option -o pipefail before RUN with a pipe in.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install APCU.
RUN printf "\n" | pecl install apcu && \
    docker-php-ext-enable apcu

# Install OAuth, xDebug and Redis.
RUN printf "\n" | pecl install oauth redis xdebug-2.9.8 && \
    docker-php-ext-enable oauth redis xdebug

# Install Composer.
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# Copy PHP ini files.
COPY docker/php/ini/* /usr/local/etc/php/conf.d/

# Copy PHP-FPM configuration files.
COPY docker/php/conf/www.conf /usr/local/etc/php-fpm.d/www.conf

# Configure PHP.
RUN mkdir /var/log/php && \
    chown -R www-data:www-data /usr/local/etc/php/conf.d \
       /usr/local/lib/php/data \
       /var/log/php \
       /var/www && \
    mkdir -p /run/php && \
    touch /run/php/php8.1-fpm.pid && \
    chown www-data:www-data /run/php/php8.1-fpm.pid && \
    touch /var/log/php8.1-fpm.log && \
    chown www-data:www-data /var/log/php8.1-fpm.log

# Copy sources, the actual context of docker is the "root" directory.
COPY --chown=www-data:www-data ./composer.json  /var/www/html/
COPY --chown=www-data:www-data ./composer.lock  /var/www/html/
COPY --chown=www-data:www-data ./config  /var/www/html/config
COPY --chown=www-data:www-data ./web  /var/www/html/web

# Add Drush launcher (drush is managed with composer).
RUN curl -L -o /usr/local/bin/drush https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar && \
    chmod +x /usr/local/bin/drush

# Set Entrypoint.
COPY docker/php/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Fixed working directory.
WORKDIR /var/www/html

# Change user:group for www-data.
USER www-data:www-data

# Create GumpPHP config file to prevent composer prompt.
RUN touch grumphp.yml && \
    \
# Install composer dependencies.
    COMPOSER_MEMORY_LIMIT=-1 /usr/local/bin/composer install --optimize-autoloader --no-dev --prefer-dist

CMD ["php-fpm"]
