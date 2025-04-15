# Build stage: Install dependencies and build the app
FROM oven/bun:1.2.9 AS build
WORKDIR /opt/app

# Copy package files and install dependencies
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile --ignore-scripts

# Copy the rest of the project files
COPY . .

# Run build process
RUN bun run build

# Module stage: Install production dependencies
FROM oven/bun:1.2.9 AS module
WORKDIR /opt/app

# Copy package files and install production dependencies
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile --ignore-scripts --production

# Final stage: Set up the production image
FROM oven/bun:1.2.9-slim

WORKDIR /opt/app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libvips-dev \
    zlib1g-dev \
    libpng-dev

# Set environment variable
ARG NODE_ENV=production
ENV NODE_ENV=$NODE_ENV

# Copy necessary files from build and module stages
COPY --from=module /opt/app/node_modules ./node_modules
COPY --from=build /opt/app/dist ./
COPY --from=build /opt/app/.strapi ./.strapi
COPY --from=build /opt/app/public ./public
COPY --from=build /opt/app/.strapi-updater.json ./.strapi-updater.json
COPY --from=build /opt/app/package.json ./package.json

# Start the app
CMD ["bun", "run", "start"]
