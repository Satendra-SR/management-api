FROM node:dubnium-alpine as dist
WORKDIR /tmp/
# for bcrypt
RUN apk update && apk --no-cache add --virtual builds-deps build-base python
# To handle 'not get uid/gid'
RUN npm config set unsafe-perm true
RUN npm install node-gyp -g
COPY package.json package-lock.json tsconfig.json tsconfig.build.json ./
COPY src/ src/
RUN npm install
RUN npm run build

FROM node:dubnium-alpine as node_modules
WORKDIR /tmp/
RUN apk update && apk --no-cache add --virtual builds-deps build-base python
COPY package.json package-lock.json ./
RUN npm install --production

FROM node:dubnium-alpine
WORKDIR /usr/local/app
COPY --from=node_modules /tmp/node_modules ./node_modules
COPY --from=dist /tmp/dist ./dist
COPY --from=dist /tmp/package.json ./package.json
EXPOSE 3000