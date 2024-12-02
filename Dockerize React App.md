# To dockerize a react app:
1. Create a Dockerfile based on Node image, and add CMD to run the react app "npm start"
2. Build the image
3. Run the container with:
 * -p flag to expose the port 3000 to the host machine
 * -it flag to run the container in interactive mode (React won't start properly without it)
 * Since the react works with JS that is running inside the browser and not inside docker container, we can't type the server container name in the axios request like we did with the server container, instead we will use the default IP address of the host machine (localhost) to make the request to the server container.
 * Also there is no need to put the frontend app in the same network as the server container(--network flag) because the frontend app is running inside the browser and not inside the container. 
 * Only the server container + the mongodb container need to be in the same network. 
 * Data persist should be done on the mongodb container, with a Named Volume.

 # EXAMPLES OF COMMANDS, WHEN RUNNING ALL 3 CONTAINERS (FRONTEND, SERVER, MONGODB) IN THE SAME TIME:
* 1. FRONTEND: 
```bash
docker run --name frontendContainerName -d --rm -p 3000:3000 -it frontendImageName
```
* 2. SERVER:
```bash
docker run --name serverContainerName -d --rm -p 3001:3001 --network mynetwork serverImageName
```
* 3. MONGODB:
```bash
docker run --name mongodb -d --rm -p 27017:27017 --network mynetwork -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=example mongo
```