# Stage 1
FROM node:alpine AS root-build

WORKDIR /root-app

COPY . /root-app/

ENV NODE_ENV=production

RUN yarn install
RUN yarn build

# Stage 2
FROM node:alpine AS ui-build

COPY --from=root-build /root-app/build app

# Create work directory
WORKDIR /app

# production environment
FROM nginx:stable-alpine

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

RUN rm -rf /usr/share/nginx/html/*

COPY --from=ui-build /app /usr/share/nginx/html

EXPOSE 3000 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]


