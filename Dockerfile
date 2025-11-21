# ---------- STAGE 1: BUILD REACT APP ----------
FROM node:18 AS build
WORKDIR /app

COPY package*.json ./

# Installer toutes les dépendances (prod + dev)
RUN npm install

COPY . .

RUN npm run build

# ---------- STAGE 2: SERVE STATIC FILES ----------
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=build /app/build .

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
