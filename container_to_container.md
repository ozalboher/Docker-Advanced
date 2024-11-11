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
* It should be noted that once this container is connected to a network we can run it without exposing the port to the host machine, as the serverContainerName is connected to the network and can communicate with the mongodb container. So you can delete the "-p 3000:3000" flag from the run command.