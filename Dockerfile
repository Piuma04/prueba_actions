# Dockerfile

# --- Etapa 1: Build (Construcción) ---
# Usamos una imagen de Node para construir la app
FROM node:lts-alpine AS builder
WORKDIR /app

# Copiamos solo los archivos de dependencias e instalamos
COPY package*.json ./
RUN npm ci

# Copiamos el resto del código y construimos la app
COPY . .
RUN npm run build
# 'npm run build' crea la carpeta 'dist'

# --- Etapa 2: Production (Producción) ---
# Usamos una imagen de Node más ligera para correr la app
FROM node:lts-alpine
WORKDIR /app

# Copiamos solo lo necesario de la etapa de 'build'
COPY --from=builder /app/dist ./dist
COPY package.json ./

# Instalamos SOLO las dependencias de producción (ej. 'vite' para 'preview')
RUN npm ci --omit=dev

# Exponemos el puerto que usa 'vite preview' (suele ser 4173 o 3000)
# Revisa tu terminal al correr 'npm run preview' para estar seguro
EXPOSE 4173

# El comando para iniciar la app
CMD [ "npm", "run", "preview" ]