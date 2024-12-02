# Laravel and PHP

- For containers using a PHP language server, you also need to install Laravel.
- Laravel is a PHP framework that is used to build web applications.
- Unlike node that which is the framework + language in one.
- Managing package installations will be done with something called 'COMPOSER'. which is the equivilant for npm (node package manager)

# Target setup:
## To achieve this we will use 6 different containers.
##  3 container apps that will communicate together:
- 1. Nginx Web Server container - to handle requests/responds to the web
- 2. PHP interpreter container - this container will have access to the php source code folder, to be able to run the php code.
- 3. MySQL Database container - to handle the database (MySQL is more common use case with php, though mongodb can also work)
## 3 utilities containers:
- 4. Composer - for managing lavarel packages installment
- 5. Laravel Artisan - 
- 6. npm - some JavaScript packages will be used so we also need npm.

# 1 First let's dive in on how to build the Nginx Server container:

- Create a new folder called 'nginx' in the root directory. and create a new file called 'default.conf' in it.(that file will hold the code for the server and the exposed port)
- Create a yaml file called 'docker-compose.yml' in the root directory and configure the server container:
```yaml
services:
    server:
        image: nginx:stable-alpine
        container_name: nginx-server
        ports:
            - "8000:80"
        volumes:
            - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
            - ./src:/var/www/html # this is the new line that was added after finishing the laravel installation in end of step 3.
```
- The image is the official Nginx image from docker hub.
- The container name is nginx-server
- The ports are mapped to 8000:80 as the manual for nginx image suggests.
- The volume will bind a local configuration file (default.conf) to a specific location (which is instructed in the documentation of the nginx image) to the container. And make it Read-Only(ro).
- The default.conf file will be created in the nginx folder in the root directory.(like the server.js code file)

# 2 Next - the PHP container:
- Create a dockerfiles folder to hold the Dockerfile needed for the PHP container(and any further containers that will need a Dockerfile).
- Name the dockerfile php.dockerfile
```dockerfile
FROM php:7.4-fpm-alpine
WORKDIR /var/www/html
RUN docker-php-ext-install pdo pdo_mysql # extensions that are needed for the php to work with mysql, and this command is needed to be executed from the right folder - so this is why we added the WORKDIR command above with a specific path.
```
* Note there is no CMD/ENTRYPOINT command in this dockerfile (like npm start in node.js) because the base image for this container has a running command out-of-the box.

- Now configure the docker-compose.yml file to include the PHP container:
```yaml
services:
    php:
        build: 
            context: ./dockerfiles
            dockerfile: dockerfiles/php.dockerfile
        volumes:
            - ./src:/var/www/html:delegated # delegated is a performance optimization for the volume, it is not necessary. It just means that changes would not reflect as fast as they would, in this case I don't really need to "see" the changes in real time so it is fine to use it.
```
- The php is set to use with a port configuration of 9000. I will not added to the yaml, but instead to the default.conf file in the nginx folder.
- The volume is set to bind the source code folder to the container's working directory.
- So make sure to create a src folder in the root directory to hold the php files.

# 3 The COMPOSER container(utility):

- Create a dockerfile called composer.dockerfile in the dockerfiles folder.
```dockerfile
FROM composer:latest
WORKDIR /var/www/html
ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]
```
- And configure the docker-compose.yml file to include the composer container:
```yaml
services:
    composer:
        build:
            context: ./dockerfiles
            dockerfile: dockerfiles/composer.dockerfile
        volumes:
            - ./src:/var/www/html
```
- * The composer container will be used to install Laravel packages, the source code folder will be binded to the container's working directory. And every package that will be installed will be reflected to the source code folder.(thanks to the bind mount - which points the workdir to where it should "look" for the files, which means at the end that the files sits physically inside the src folder. while a named volume would simply put it inside the docker container in a place docker will decide on its own).
- Now run the composer container with the following command:
```bash
docker-compose run --rm composer create-project --prefer-dist laravel/laravel .
```
- * Note that the '.' means it will be installed in the root folder, and since the root folder is configured in the dockerfiler: WORKDIR /var/www/html, it will be installed there. And will be reflected back in the src folder.(thanks to the bind mount).

- After running the command, the Laravel framework will be installed in the src folder.
- Next, navigate to the src folder and look for the .env file. There are some things that needs to be changed there, right now it is configured to work with laravel's default database, but we want to use our own database container. So change accordingly to be same as the info in the mysql database container -> that is written in mysql.env file.
- and where you see DB_HOST=127.0.0.1 change it to DB_HOST=mysql (the name of the mysql container in the docker-compose.yml file).
- Should look like this:
```env
DB_CONNECTION=mysql     # this is the default connection type for laravel
DB_HOST=mysql           # this is the name of the mysql container in the docker-compose.yml file.
DB_PORT=3306            # this is the default port for mysql
DB_DATABASE=homestead   # this is the database name that is set in the mysql.env file.
DB_USERNAME=homestead   # this is the username that is set in the mysql.env file.
DB_PASSWORD=secret      # this is the password that is set in the mysql.env file.
```
## Before continuing, let us go back to step 1 (the nginx server container) and now add the src folder we just created (of the laravel framework) to the nginx server container, as a bind mount. why? because the server container needs to know where the php files are located, so it can serve them.
- Add the following line to the volumes section of the nginx server container in the docker-compose.yml file:
```yaml
        volumes:
            - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro 
            - ./src:/var/www/html # this is the new line that was added.
```
- * Up to this point lets run only the 3 containers that we have configured so far, and see if the laravel framework is working.
```bash
docker-compose up -d server php mysql
```
