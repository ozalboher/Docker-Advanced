FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

RUN RUN docker-php-ext-install pdo pdo_mysql 

