# Docker-Advanced

# Difrences between Docker run and Docker start: 

## The code below will CREATE a new container from the image and START it.
```bash
docker run image_name
 ```
## The code below will only START an EXISTING stopped container.
```bash
 docker start container_name
 ```

# Stopping a container VS Removing a container:

## stopping a container does not mean it is removed. It is just stopped.
## Container that is not removed will STILL have its own modified data in it.
## This means if i create and run a container with docker run and then stop it, I can start it again with docker start. unless I remove it completely with docker rm container_name.
## or if I remove it automatically with the --rm flag in the docker run command.
## The --rm flag will remove the container when it is stopped.
## The --name flag will give the container a name. so it can be started/stopped with the name instead of the container id.
```bash
docker run -p 8080:80 -d --name containerName --rm imageName
```

# It is important to remember that when IMAGE is created it has its own file system that is created and seperated from the host (my local pc) file system.
# And when the container is created from the image, it adds an additional layer on top of the image file system that is read/write. This means that the container can modify the file system of the image, but those changes will live only in the container and not in the image itself.

# Docker Volumes:
## So after understanding that by deleting (not stopping) a container it also deletes the changes/data we made in the container, we can solve this issue by using VOLUMES - to store the data outside of the container. And when a container is then started fresh again it can use the data from the volume. A volume is a folder with data that is gonna be created & stored in the host file system (in my local pc - in a place docker will automatically choose).

## So volume is the solution, but there are 2 types of volumes. Anonymous volumes will be created if we only write the volume command in the Dockerfile.
```Dockerfile
VOLUME [ "/app/data" ]
```
## And anonymous volume data will not be kept after container is DELETED(not stopped), so we need to use NAMED VOLUMES, which will need to be specified also in the terminal when creating the container -> in the docker run command.
## it should be noted that anonymous VOLUME will technically only be deleted when we run the container with --rm flag. But if we do not run the container with --rm flag, and delete the container afterwise with docker rm container_name, the anonymous volume will still be there. But it won't really do any good, since if we do docker run again with the same image, it will just create a new unrelated anonymous volume, and the old one will be left there, unused.

## Named volumes are created with the -v flag, then the name for the volume, and then the path where the file/folder I want to mount onto the volume.
```bash
docker run -v my-volume:/app/some_folder_or_file 
```

# Bind Mounts:
## Similar to Named Volumes, where we used it to presist the data outside of the container (in a location that docker chooses automatically) We only used it to keep specific data of the app that it may be saving - like the feedback information.
## But what if we want to keep the whole app outside of the container? So we can edit the app code and see the changes in the app immediately. This is where Bind Mounts come in. Bind Mounts are used to keep the whole app in a volume outside of the container and since that volume will be binded to it, we can edit the app code and see the changes in the app immediately. This is done by specifying the *absolute path address* of the app in the host file system, and then the path of the app in the container file system. So very similar to Named Volumes, but instead of specifying the name of the volume, we specify the absolute path address of the app in the host file system.
```bash
docker run -v /absolutePathAddress:/app
```
## This will bind the /absolutePathAddress folder of our app in the host file system to the /app folder in the container file system. So any changes made in the host file system will be immediately reflected in the container file system.
## Make sure Docker is allowed to access the host file system. This is done by going to Docker Desktop -> Settings -> Resources -> File Sharing -> Add the folder where the app is located.

## Important! if we use this method of creating a bind mount pointing to all the app data from the absolute path address, then we essentially will run the app from the absolute path address (of the entire app data) do not have node_modules folder inside, so even though the Dockerfile has the command to RUN npm install, it will not work in this case. So running the container with this bind mount flag is essentially overwriting the copy instruction of the package.json and the npm install in the Dockerfile.
## So to fix this we will create an additional anonymous volume for the node_modules folder, so it is not overwritten by the bind mount. This is done by adding the volume command in the Dockerfile for the node_modules folder.
```Dockerfile
VOLUME [ "/app/node_modules" ]
```
## Or by simply adding an additional volume flag, for the anonymous volume, in the docker run command.
```bash
docker run -v /absolutePathAddress:/app -v /app/node_modules 
```
## So by now running the container with all of the flags we discussed (container name and image name etc..) we should come up with something like this:
```bash
docker run -d -p 8080:80 --rm --name containerName -v "absolute_app_path:/app" -v /app/node_modules imageName
```
## So now we have the app data binded & mounted to the host file system, and the node_modules folder is stored in an anonymous volume, so it is not overwritten by the bind mount. Using both anonymous volumes and bind mounts is called merging volumes. 
## Note that by merging volumes, Docker maintains clashes between the bind mount and the anonymous volume by giving priority to the bind mount(cuz its the largest). So if there is a file in the bind mount and the anonymous volume with the same name, the file in the bind mount will be used. but if the file is NOT in the bind mount, then the file in the anonymous volume will be used. hence the node_modules folder will be used from the anonymous volume, and the rest of the app data will be used from the bind mount.
## If I want to live update the server.js file I might need to consider using nodemon.
