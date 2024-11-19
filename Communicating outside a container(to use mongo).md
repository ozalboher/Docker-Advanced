# Connecting MongoDB container to the app.js/server.js container
## MongoDB is the database that is configured in my app.js/server.js file, but once the app.js/server.js file is running as a container, it will NOT be able to connect to the MongoDB database (because it is running on the local machine).....The solution is to run the MongoDB database in a container as well. I dont need to create a Dockerfile for the MongoDB container, I can use the official MongoDB image from Docker Hub.

* Here we will cover 3 possible ways to make mongoDB work in the app.js/server.js container:
* All of which are done by running the MongoDB container in a separate container and making the app.js/server.js container communicate with it.



1. Using the IP address of the running MongoDB container.
- Run Mongo as a container using the official Mongo Image and name it mongodb(You can name it whatever you want):
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
2. Using the IP address that is provided by the official MongoDB image.
- More simple then the first way, I dont need to do anything, except to just run the MongoDB container from the official image (like before) but now I need to expose the port 27017:
```bash
docker run -d --name mongodb -p 27017:27017 mongo
```
- And I need to type in the server.js/app.js file: 'host.docker.internal'
```javascript
const mongoose = require('mongoose');
mongoose.connect(
  'mongodb://host.docker.internal:27017/swfavorites', // localhost was replaced with host.docker.internal
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
*** Also make sure to EXPOSE the port 3000 (or whatever port you are using in the app.js/server.js file) in the Dockerfile that is related to the app.js/server.js container + make sure to run the app.js/server.js container with the -p flag to expose the port 3000 to the host machine.
```bash
docker run --name serverContainerName -d --rm -p 3000:3000 serverImageName
```

3. Using docker network
 In the 1st way we 'hardcode' the IP address of the mongodb container, we can look into a better way to make the containers communicate with each other. We can use Docker networks to make the containers communicate with each other using the - mongodb container name - instead of the IP address.

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