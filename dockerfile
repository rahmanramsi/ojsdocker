############################################
# Base Image
############################################

# Learn more about the Server Side Up PHP Docker Images at:
# https://serversideup.net/open-source/docker-php/
FROM serversideup/php:8.2-fpm-apache as base

# Switch to root so we can do root things
USER root

COPY ./.dockerdata/entrypoint.d /etc/entrypoint.d

# Install the intl extension with root permissions
RUN install-php-extensions intl bcmath gd exif ftp


############################################
# Production Image
############################################
FROM base as release

ENV OJS_VERSION=3.5.0-1 \
    APP_DIR=/var/www/html

# RUN mkdir $APP_DIR
# RUN chown -R www-data:www-data $APP_DIR


# Download and extract OJS
ADD https://pkp.sfu.ca/ojs/download/ojs-${OJS_VERSION}.tar.gz /tmp/
# ADD ojs-${OJS_VERSION}.tar.gz $APP_DIR

# Create the public directory
RUN mkdir -p $APP_DIR/public

# RUN mv $APP_DIR/ojs-${OJS_VERSION} $APP_DIR/public
RUN tar -xzf /tmp/ojs-${OJS_VERSION}.tar.gz -C /tmp \
    && mv /tmp/ojs-${OJS_VERSION}/* $APP_DIR/public \
    && rm -rf /tmp/ojs-${OJS_VERSION} /tmp/ojs-${OJS_VERSION}.tar.gz

RUN chown -R www-data:www-data $APP_DIR

# COPY --chown=www-data:www-data . /var/www/html/public

# ENV SSL_MODE=mixed

USER www-data
