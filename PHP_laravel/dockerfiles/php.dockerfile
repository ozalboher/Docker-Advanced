FROM php:8.2-fpm-alpine

WORKDIR /var/www/html

# Disable SSL verification for apk (for pc with antivirus that blocks apk)
RUN set -ex \
    && echo "http://dl-cdn.alpinelinux.org/alpine/v3.16/main" > /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/v3.16/community" >> /etc/apk/repositories \
    && apk update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.16/main --allow-untrusted \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.16/main --allow-untrusted \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.16/community --allow-untrusted

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql