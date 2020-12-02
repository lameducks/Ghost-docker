## 1st stage

FROM node:14-alpine3.12 as build

ENV GHOST_VERSION 3.39.0-mod.1

RUN apk add --no-cache git \
    && git clone --recurse-submodules https://github.com/lameducks/Ghost.git \
    && cd Ghost \
    && git -c advice.detachedHead=false checkout refs/tags/v$GHOST_VERSION \
    && yarn install --prod \
    && cp -rp node_modules / \
    && yarn install \
    && yarn global add grunt-cli \
    && grunt release \
    && mv /node_modules .build/release

COPY overlay /Ghost/.build/release/

## 2nd stage

FROM node:14-alpine3.12

ENV NODE_ENV production
ENV GHOST_INSTALL /var/lib/ghost
ENV GHOST_CONTENT /var/lib/ghost/content

EXPOSE 2368
VOLUME ["$GHOST_CONTENT/images", "$GHOST_CONTENT/settings"]
WORKDIR $GHOST_INSTALL
CMD ["node", "index.js"]

RUN rm -rfv /tmp/*

COPY --from=build /Ghost/.build/release $GHOST_INSTALL
