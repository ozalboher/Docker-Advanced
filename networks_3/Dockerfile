FROM node:alpine

WORKDIR /app

COPY package.json .

# Type This is to avoid SSL error while installing npm packages:

# RUN npm config set strict-ssl false

RUN npm install

COPY . /app

CMD ["node", "app.js"]