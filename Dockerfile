## Multi-stage Dockerfile for building a Vite app and serving with nginx

# Use Debian-slim for the build stage to avoid musl/glibc compatibility issues
FROM node:18-bullseye-slim AS builder
WORKDIR /app

# Install a couple of small utilities that some npm packages may need at build-time
RUN apt-get update \
	&& apt-get install -y --no-install-recommends git ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

# Copy package manifests and install dependencies (including devDependencies needed for build)
COPY package*.json ./
RUN npm ci --silent

# Copy rest of the project and run the build
COPY . .
RUN npm run build

# Production stage: lightweight nginx image that serves the generated `dist` folder
FROM nginx:stable-alpine AS production
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
