# common stage
FROM node:12-alpine as app_common
WORKDIR /usr/src/app
RUN yarn global add react-scripts
COPY package.json yarn.lock ./
RUN yarn install
COPY . ./


# development stage
FROM app_common AS app_development
CMD ["yarn", "start"]

# build stage
FROM app_common AS app_build
RUN yarn build

# nginx stage
FROM nginx:1.18-alpine
COPY docker/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
WORKDIR /usr/src/app/build
COPY --from=app_build /usr/src/app/build ./
ENTRYPOINT ["nginx", "-g", "daemon off;"]
