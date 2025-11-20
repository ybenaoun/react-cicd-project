FROM nginx:alpine

WORKDIR /app
COPY package*.json ./
COPY . .
RUN npm install
RUN npm run build
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
