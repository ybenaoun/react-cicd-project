FROM node:lts-alpine
WORKDIR /app
COPY package*.json ./
RUN apk add --no-cache nodejs npm
COPY . . 
RUN npm run build
CMD ["npm", "start"]
EXPOSE 3000
