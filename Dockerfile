# Multi-stage Dockerfile for building Vite app and serving with nginx
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci --silent
COPY . .
RUN npm run build

# Production stage
FROM nginx:stable-alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
