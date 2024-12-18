# Docker-Advanced

# **DETACHED & ATTACHED MODE:**

## 1. When using 'docker start' to start a container, it will run in DETACHED mode by default.
## 2. When using 'docker run' to start a container, it will run in ATTACHED mode by default. (But with adding -d will make it detached).

## The difference between detached and attached is the output of the container. In detached mode, the output will NOT be shown in the terminal.
## In attach mode, the output WILL be shown in the terminal. Even though real-time output is shown, what about input? can I interact with the terminal/container? The answer is: Yes but only if you run the container in INTERACTIVE mode, using the -i and -t flags. 
## -i flag for enabling interactive mode, -t flag for enabling terminal mode.
```bash 
docker run -it ubuntu
```
# Delete Containers: 
```bash
docker rm container1 container2
```
# Delete Images:
```bash
docker rmi imageID1 imageID2
```
## Image can't be removed when a container is associated to it, doesn't matter if that container is on run or stop. 
# Start a container with --rm to delete it as soon as it stops. 


# **COPY TO CONTAINER:**
## Copying files to and from containers is useful for pulling out logs or copying in a new configuration file. 

# Copy files host to container:
# specify the src folder+file(or all with `.`) and then the dst folder/file.
```bash
docker cp folder/. containerID:/folder
```
# Copy files container to host:
# specify the src folder+file(or all with `.`) and then the dst folder/file.
```bash
docker cp containerID:/folder/. folder
```
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

## Named volumes are created with the -v flag, then the name for the volume, and then the path where the folder I want to mount onto the volume.
```bash
docker run -v my-volume:/app/some_folder
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
## We might wanna consider making the binded volume read-only, so the running container can't mess with the app only I can manually change code/files. This is done by adding the :ro flag at the end of the bind mount command.
```bash
-v "absolute_app_path:/app:ro" 
```
## And to still keep like a certain folder to be readable and writable by the container, we can create a 3rd volume as a Named Volume for that purpose:
```bash
docker run -d -p 8080:80 --rm --name containerName -v "absolute_app_path:/app:ro" -v /app/node_modules imageName -v my-volume:/app/some_folder
```
## And we can add a 4th volume for the temp folder, that can be an anonymous volume, since it is not needed after the container is deleted.
## And in this case because there are already a couple of different volumes in-use, the anonymouse volume will also be added to the terminal command and NOT in the Dockerfile.


# Summary of Docker Volumes: 
1. Anonymous Volumes: Created by writing VOLUME command in the Dockerfile. Will be deleted when the container is deleted.
   They are good for outsourcing temporary data that is not needed after the container is deleted, but can still offload the data from the container to the host file system. 
2. Named Volumes: Created by using the -v flag in the docker run command only. Will not be deleted when the container is deleted.
3. Bind Mounts: Created by using the -v flag in the docker run command only. Will not be deleted when the container is deleted. 
   But here we can specify exact files to be binded from the host file system to the container file system. Typical use case - live data.

# Docker Volume Inspection:
## To inspect the volumes that are created, we can use the docker volume ls command.
```bash
docker volume ls
```
## To inspect a specific volume, we can use the docker volume inspect command.
```bash
docker volume inspect volume_name
```
## Under "Mountpoint" we can see the path where the volume is stored, It should be noted that this path will not be accessible from the host file system, it is in a virtual machine docker creates to run the containers.
## Under "Options" we can see if the volume is read-only or not.

## TO REMOVE A VOLUME:
```bash
docker volume rm volume_name
```
## If the volume is in use by a container, it will not be removed. So we need to remove the container first, and then remove the volume.

