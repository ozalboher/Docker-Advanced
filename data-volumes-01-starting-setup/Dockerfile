FROM node:alpine

WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app

EXPOSE 80


# VOLUME [ "/app/feedback" ] # This will create an anonymous volume so instead I will use a NAMED volume that will be created in the terminal.
# TYPE_IN_TERMINAL: docker run -d -p 8080:80 --rm --name feedback-app -v feedback:/app/feedback data-vol

# For using a BIND MOUNT + Anonymous Volume (to mount node_modules) make sure to include 1 of the following lines:
# VOLUME [ "/app/node_modules" ]
# TYPE_IN_TERMINAL:  docker run -d -p 8080:80 --rm --name feedback-app -v "absolutePath":/app -v /app/node_modules data-vol
CMD ["node", "server.js"]

