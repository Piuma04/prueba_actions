# Dockerfile

# --- Etapa 1: Build (Construcción) ---
FROM node:lts-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# --- Etapa 2: Production (Producción) ---
FROM node:lts-alpine
WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY package*.json ./  
# <-- Arreglado: Copia 'package.json' Y 'package-lock.json'

# 'npm ci' ahora funciona Y 'vite' se instalará porque está en 'dependencies'
RUN npm ci --omit=dev

EXPOSE 4173
CMD [ "npm", "run", "preview" ]