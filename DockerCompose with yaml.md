# The yaml file will automate the process of writing the building images command + configuring the containers (and the network), so we dont have to do it manually.

- instead of typing the long commands with all of the different flags and options, we can use a yaml file to automate the process.
- The yaml file will define the services, the networks, the volumes, and the configurations of the containers.

- 1. specify the verison of the yaml file
- 2. define the services (containers) and their configurations. inside the services we will write values that represent the configurations of the containers. with a ':' after the service name. single value without ':' will be written with a '-' before the value.
     for example:

```yaml
version: "3.8"
services:
  mongodb:
    image: mongo
    volumes:
      - mongodb_data:/data/db
    environment:
      #MONGO_INITDB_ROOT_USERNAME: root
      #MONGO_INITDB_ROOT_PASSWORD: example
    env_file:
      - ./env/mongo.env
    networks:
      - mynetwork 
  backend:
  frontend:
  volumes:
    mongodb_data:
```
* I can pull the env variables from a file using the env_file key. instead of writing the env variables in the yaml file.(this is more secure when excluding the env file with gitignore).
* By default, the containers will be connected to the default network. So there is no need to specify the network for the containers. But if we want to connect the containers to a specific network, we can specify the network name in the networks key.
* In the docker-compose.yml file, the volume mongodb_data is a named volume because it is referenced by name in the service definition. However, to ensure it is treated as a named volume, it should also be defined at the root level under the volumes key
# The docker-compose command
```bash
docker-compose up
```
- This command will build the images and start the containers according to the configurations in the yaml file.