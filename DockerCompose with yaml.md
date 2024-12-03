# The yaml file will automate the process of writing the building images command + configuring the containers (and the network), so we dont have to do it manually.

- instead of typing the long commands with all of the different flags and options, we can use a yaml file to automate the process.
- The yaml file will define the services, the networks, the volumes, and the configurations of the containers.

- 1. specify the verison of the yaml file(no need in the new versions of docker-compose).
- 2. define the services (containers) and their configurations. inside the services we will write values that represent the configurations of the containers. with a ':' after the service name. single value without ':' will be written with a '-' before the value.
     for example:

```yaml
services:
  mongodb: # the name of the container(+the folder name)
    image: mongo
    volumes: # a volume property for the container
      - mongodb_data:/data/db
  volumes:
    mongodb_data: # configuration for the volume that we then can use inside the service (container).
```
# Services are basically the containers I will run. The name for the service is up to me to choose. Note that Deocker will automatically take the name and add the folder name which is associated to. To force only an explicit name, add:
```yaml
container_name: myContainer
```
* Services (containers) that I would want to add a property like a volume or network, I need to make sure I am ALSO adding it as a property in the ROOT level of the yaml file. As seen in the example above I am using a named volume that I defined in the root level of the yaml file. (For a bind mount I would not need to define it in the root level). 
* I can pull the env variables from a file using the env_file key. instead of writing the env variables in the yaml file.(this is more secure when excluding the env file with gitignore).
* By default, docker compose will connect all containers to a new default network. So there is no need to specify the network for the containers. But if we want to connect the containers to a specific network, we can specify the network name in the networks key.
## The docker-compose command
```bash
docker-compose up -d # add -d for detached mode.
```
- This command will build the images and start the containers according to the configurations in the yaml file.
## The docker-compose down command
```bash
docker-compose down -v # -v flag will remove the volumes as well.
```
## Force re-build of image
- Docker Compose will only build an image once by default, then the next time you will run 'docker-compose up' if it sees the image was already built, it will skip it. Which can be quiet useful, though in a case we would want to build it anyway we can force docker to do so with 
```bash
docker-compose up --build
```

# Up to this point I automated with docker compose some of the commands I would typically use to build and run a mongo container, but the mongo image is already available on docker hub. so I basically did not build it only pulled it and added some running configurations.
# What if I want to build my own image and then run it with docker compose? 
- I can use the build key in the yaml file to specify the path to the Dockerfile that I want to build. 
- I can also specify the context of the build with the context key.(the path to the folder that contains the Dockerfile).
- I can also specify the dockerfile name with the dockerfile key. see example:
```yaml
services:
  backend:
    build:
      context: ./backend # the path to the folder that contains the Dockerfile.
      dockerfile: Dockerfile # the name of the Dockerfile that I want to build.
```
- shorter way to write the build key:
```yaml
services:
  backend:
    build: ./backend # the path to the folder that contains the Dockerfile(as long as the Dockerfile is named exactly - Dockerfile).
```

# Sometimes a container might be dependent on another container, for example our backend container will not work if the mongodb container is not valid and up&running.
- to include such a case use this:
```yaml
services:
  backend:
    build: ./backend
    depends_on: #
      - mongodb # the name of the container that this container is dependent on.
```
# We learned that in order to run a react app in a container, we need a to run the container in interactive mode with the ' -it ' flag. Here in Docker Compose, you can add a configuration to make the input accesable with:
- stdin_open: true  //will "open input" ( -i interactive)
- tty: true // will attach the terminal to the open input (-t terminal)

# Force docker-compose to build the images again
- * if an image is already built, docker-compose will not build it again. That means if I make changes to the Dockerfile, the changes will not be reflected in the image. To force docker-compose to build the images again, I can use the --build flag with the up command.
```bash
docker-compose up --build
```
- * it will still use the cach for stuff that were unchanged so it will be faster than the first time.