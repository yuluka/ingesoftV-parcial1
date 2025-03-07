FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
COPY .env .env

RUN npm install --only=production

COPY . .

EXPOSE 8080

CMD ["node", "app.js"]
