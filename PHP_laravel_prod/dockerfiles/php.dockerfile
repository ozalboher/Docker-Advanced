FROM php:8.2-fpm-alpine
# Set the working directory to the address where the laravel application will be stored.
WORKDIR /var/www/html 

# # Disable SSL verification for apk and manually fetch APKINDEX files
# RUN set -ex \
#     && echo "http://dl-cdn.alpinelinux.org/alpine/v3.16/main" > /etc/apk/repositories \
#     && echo "http://dl-cdn.alpinelinux.org/alpine/v3.16/community" >> /etc/apk/repositories \
#     && mkdir -p /var/lib/apk \
#     && wget --no-check-certificate http://dl-cdn.alpinelinux.org/alpine/v3.16/main/x86_64/APKINDEX.tar.gz -O /var/lib/apk/main.tar.gz \
#     && wget --no-check-certificate http://dl-cdn.alpinelinux.org/alpine/v3.16/community/x86_64/APKINDEX.tar.gz -O /var/lib/apk/community.tar.gz \
#     && tar -xzf /var/lib/apk/main.tar.gz -C /var/lib/apk \
#     && tar -xzf /var/lib/apk/community.tar.gz -C /var/lib/apk \
#     && apk update --no-cache \
#     && apk add --no-cache --allow-untrusted ca-certificates

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql
# Ensures the default user has the right permissions to write to the directory
RUN chown -R www-data:www-data /var/www/html