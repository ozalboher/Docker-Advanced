# To enable communication between the container and the MongoDB database

   - Install MongoDB on your local machine. 

1. Enter the following code in the server.js to connect the container to the mongoDB database:
```javascript
const mongoose = require('mongoose');
mongoose.connect(
  'mongodb://host.docker.internal:27017/swfavorites',
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
