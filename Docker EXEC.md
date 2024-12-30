# Docker EXEC: Executing commands in a running container

- When we wanted to have a terminal to interact when running a container we would typically use the -it flag. There is also the EXEC command which does the same thing but can be used anytime on any running container. So not just with the -it only when we run the container but also if the container is already running.

# ENTRYPOINT & CMD - In the Dockerfile

- ENTRYPOINT and CMD are both instructions in a Dockerfile that define what command to run when a container is started from the image. The main difference between CMD and ENTRYPOINT is that CMD can be overridden when the container is run with a new command. ENTRYPOINT cannot be overridden when the container is run with a new command. So when typing a command with an ENTRYPOINT, it will be added to the command that is already in the ENTRYPOINT, for example, if I would want to run the container with the "npm install" command I can shorten the command:

  ```Dockerfile
    ENTRYPOINT ["npm"]
  ```
- Now when I run the container with the command "install" it will be added to the ENTRYPOINT command and the full command will be "npm install". so now further on commands that needs the npm word in front will be shortened. I can type "start" and it will be "npm start" and so on. 
For example, if I would want to run the container with the "npm install" command I can shorten the command:

  ```Dockerfile
    CMD ["install"]
  ```