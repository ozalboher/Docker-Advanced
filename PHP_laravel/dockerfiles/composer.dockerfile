FROM composer:latest

WORKDIR /var/www/html

# Copy application files
COPY . /var/www/html

# Install PHP dependencies using Composer
RUN composer install --ignore-platform-reqs --no-dev --no-scripts --prefer-dist