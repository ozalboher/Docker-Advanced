FROM nginx:stable-alpine
# Set the working directory to /etc/ngnix/conf.d
WORKDIR /etc/ngnix/conf.d
# Copy the ngnix.conf file from the host to the current location
COPY nginx/nginx.conf .
# Rename the ngnix.conf file to default.conf
RUN mv nginx.conf default.conf  

WORKDIR /var/www/html

COPY src .


# This configuration insures we always copy a snapshot of our codebase into the image without relying on the bind mount.
# Make sure in the docker-compose file, I am refering to this dockerfile in the context of . (current directory)
# This is because I am copying the source code into the image, and the source code is in a different directory from the dockerfile
