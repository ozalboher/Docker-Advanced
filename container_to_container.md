# Container to container communication:

## Running 2 containers the server.js and the MongoDB container and making them communicate with each other.
- Run Mongo as a self container using the official Mongo Image:
```bash
docker run -d --name mongodb mongo
```
- Inspect the container in terminal:
```bash
docker container inspect mongodb
```
- Get the IP address of the container from the info under "NetworkSettings" > "IPAddress" > copy the IP address
- Paste the IP address inside the server.js/app.js file:
```javascript
const mongoose = require('mongoose');
mongoose.connect(
  'mongodb://localhost:27017/swfavorites', // replace localhost with the IP of the mongodb container
  { useNewUrlParser: true },
  (err) => {
    if (err) {
      console.log(err);
    } else {
      app.listen(3000);
    }
  }
);
```
## Since we need to 'hardcode' the IP address of the mongodb container, we can look into a better way to make the containers communicate with each other. We can use Docker networks to make the containers communicate with each other using the mongodb container name instead of the IP address.
- Create a network:
```bash
docker network create mynetwork
```
- Run the mongodb container in the network you just created:
```bash
docker run -d --name mongodb --network mynetwork mongo
```
- Now all is left to do is update the server.js/app.js file to connect to the mongodb container using the container name:
```javascript
const mongoose = require('mongoose');
mongoose.connect(
  'mongodb://containerName:27017/swfavorites', // replace containerName with the mongo container name (mongodb)
  { useNewUrlParser: true },
  (err) => {
    if (err) {
      console.log(err);
    } else {
      app.listen(3000);
    }
  }
);
```
- Now run the server.js/app.js container with the network you created:
```bash
docker run --name serverContainerName --network mynetwork -d --rm -p 3000:3000 serverImageName
```
# SUMMARY:
* It is vital to understand the 3 ways a container can establish a connection outside of it:
1. Requests to web servers/api via WWW url - always possible.
2. Requests to the local host machine via: host.docker.internal
3. Cross-Container Requests via the container IP or even better, with the container name (as long as it's configured in the same network as the other container it is communicating with). 
## At the end of each process docker will do the IP resolving technology, that will reach the target of the request, of what is called - Docker Ip resolver.