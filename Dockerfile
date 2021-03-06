# The instructions for the first stage
FROM node:10-alpine as builder
LABEL maintainer="RestQa <team@restqa.io>"
LABEL app="404_links"
LABEL name="404 lings"
LABEL description="It is a part of quality assurance to check that your markdown files doesn\'t contains broken links"
LABEL repository="https://github.com/restqa/404-links"
LABEL url="https://restqa.io/404-links"

RUN apk --no-cache add python make g++

COPY package*.json ./

RUN npm install --production
RUN npm ci --only=production

# The instructions for second stage
FROM node:10-alpine

ENV NODE_ENV=production

COPY . /restqa
COPY --from=builder node_modules /restqa/node_modules
RUN ln -s /restqa/404-links /bin/404-links

WORKDIR /restqa

ENTRYPOINT [ "404-links"]
