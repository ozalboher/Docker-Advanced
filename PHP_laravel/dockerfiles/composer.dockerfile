FROM composer:latest

WORKDIR /var/www/html

# Create a basic composer.json file
RUN echo '{}' > composer.json

# Install dependencies (none initially)
RUN composer install --no-dev --no-scripts --no-autoloader

# Copy the rest of the application code
COPY . /var/www/html/

# Generate the autoloader
RUN composer dump-autoload --optimize

ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]

#    Copy application files
#COPY . /var/www/html

#    Install PHP dependencies using Composer
#RUN composer install --ignore-platform-reqs --no-dev --no-scripts --prefer-dist