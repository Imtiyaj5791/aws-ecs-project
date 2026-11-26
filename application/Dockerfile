FROM node:26-alpine

RUN apk update && apk upgrade --no-cache

WORKDIR /app

COPY package*.json ./

RUN npm install --omit=dev

COPY src/ ./src/

EXPOSE 3000

CMD ["npm", "start"]