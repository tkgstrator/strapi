ARG BUN_VERSION=1.2.10
ARG NODE_VERSION=22.15.0
ARG VERSION=5.12.6

FROM node:${NODE_VERSION} AS node
FROM oven/bun:${BUN_VERSION}

WORKDIR /opt

ENV VERSION=5.12.6

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -fs /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
RUN ln -fs /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npx
RUN bash -c "bun create strapi@${VERSION} app \
    --no-run \
    --typescript \
    --use-yarn \
    --no-install \
    --no-git-init \
    --no-example \
    --skip-cloud \
    --dbclient postgres \
    --dbhost postgres \
    --dbport 5432 \
    --dbname strapi \
    --dbusername strapi \
    --dbpassword postgres"

WORKDIR /opt/app
RUN bun install
RUN bun strapi build