FROM node

## COPY . . 
# First dot after COPY is to copy all folders and subfolders to the source directory (host file system)
# Second dot is the destination directory(image/container file system)

# Would be better to place it all in a folder with a name like /app hence I would write:
# BASICALLY it tells docker to copy all files and folders in the current directory to the /app directory
# if there is no /app directory, docker will create one

#COPY . /app

# now before we can run the image, I would need to specify the working directory
# This is the directory where the commands/instructions will be executed
# Since i decided to copy all files to the /app directory, I would set the working directory to /app
# Agian by writing /app if there is no such folder, docker will create one.
WORKDIR /app

COPY . /app
# Now I would run the npm install command to install all dependencies
RUN npm install  

# Now I would expose the port that the application is running on. 
# Although the port is specified in the application code, I would still need to expose it in the Dockerfile
# Because the container is isolated from the host machine and other containers, I would need to manually expose the port to the host machine
EXPOSE 80
# Now I would run the npm start command to start the application.
# CMD command is used to run the application, and should always be the last command in the Dockerfile.
CMD ["npm", "server.js"]