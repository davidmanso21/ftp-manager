# Usar imagen oficial de Node.js 18
FROM node:18-alpine

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar todo el código fuente
COPY . .

# Crear directorio para datos persistentes
RUN mkdir -p data

# Exponer el puerto que usa la app
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["node", "server.js"]
