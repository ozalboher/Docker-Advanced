# Container Utility

- sometimes it might be useful to create container for a certain utility that you need to use in your project. For example, if you need to use a certain tool that is not installed on your machine, you can create a container for that tool and use it from there.

- for example if you need node and npm but you don't have it installed on your machine, you can create a container for that and use it from there. In order to run an npm init/npm install command, I need to download node to the PC. Instead I can use a container with node image and run npm install from the container and then with a Bind Mount, I can have the node_modules+package.json to be copied straight to my local machine.

## To type a command in a container when using Docker Compose:
```bash
docker-compose run <command>
```
- the run command is mandatory to type in order to run a command in a container when using Docker Compose. instead of the usual 'docker-compose up' command.
- Side note: when using the 'run' command, the container will not be removed automatically after it is stopped like it would with the 'docker-compose up'. So you can add the -rm flag to remove the container after it is stopped.

## You can also use the 'docker-compose run' to run INDIVIDUAL container at a time. For example, if you have a docker-compose.yml file with 3 services, you can run only one of them by typing:
```bash
docker-compose run --rm <service-name>
```
- this will run only the service that you specify in the command.