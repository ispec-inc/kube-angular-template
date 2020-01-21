### STAGE 1: Build ###

# We label our stage as 'builder'
FROM node:10-alpine as builder

COPY package.json ./

RUN npm set progress=false && npm config set depth 0 && npm cache clean --force

## Storing node modules on a separate layer will prevent unnecessary npm installs at each build
RUN npm i && mkdir /ng-app && cp -R ./node_modules ./ng-app

WORKDIR /ng-app

COPY . .

ARG is_build_mode_prod=false
ARG build_configuration=dev
## Build the angular app in production mode and store the artifacts in dist folder
RUN $(npm bin)/ng build --prod=${is_build_mode_prod} --configuration=${build_configuration} --build-optimizer=${is_build_mode_prod}


### STAGE 2: Setup ###

FROM nginx:1.13.3-alpine

## Copy our default nginx config

ARG nginx_conf_path=nginx/prod/default.conf
ARG nginx_htpasswd_path=nginx/prod/.htpasswd
COPY ${nginx_conf_path} /etc/nginx/conf.d/
COPY ${nginx_htpasswd_path} /etc/nginx/.htpasswd

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From 'builder' stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /ng-app/dist/browser /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
