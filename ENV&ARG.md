# ENVIROMENT VARIABLES:

1. We can set an ENV variable in the dockerfile using the ENV keyword.
The name of the variable, and then the value of the variable.
- When using the variable in the dockerfile, we use the $ sign and the name of the variable.
```dockerfile
ENV PORT 80
EXPOSE $PORT
```
- We can still change the value of the variable when running the container.
```bash
docker run -e PORT=8080 <image>
```
2. It is also possible to use it through a .env file. Create a .env file in the same directory as the dockerfile.
```.env
PORT=80
``` 
- Then when running the container, we can use the --env-file flag.
```bash
docker run --env-file ./.env <image>
```
- The ./. is to specify that the file is in the current working directory.
- Regarding security, it is a better approach to use a seperate .env file, as it is not stored in the dockerfile. (And considering you comment out the .env file in the .dockerignore file, it will not be copied to the image).

# ARGUMENTS:

1. To be able to make the Dockerfile even more flexible and dynamic, we can use ARGs.
- Arguments are just like ENV variables, but they are only available during the build process.
- They are not available during the runtime of the container.
- It could be possible to combine ARGs and ENVs to make the Dockerfile even more dynamic.
```dockerfile
ARG DEFAULT_PORT=80
ENV PORT $DEFAULT_PORT
EXPOSE $PORT
```
- When building the image, we can pass the argument.
```bash
docker build --build-arg DEFAULT_PORT=8080 -t <image> .
```
## NOTE that ARG & ENV are stuff that I may be changing more often, because they are susceptible to changes it may be a good idea to keep them last in the Dockerfile, so that the build cache will be used more efficiently.
