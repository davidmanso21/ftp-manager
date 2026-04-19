# 📦 Guía de Despliegue - FTP Manager en Render + UptimeRobot

## Descripción
Esta aplicación es un FTP Manager con autenticación JWT, gestión de archivos, generación de PDFs/Excel y conexión a servidor FTP externo.

---

## 📋 PASO 1: Subir a GitHub

### 1.1 Crear repositorio
1. Ir a [github.com](https://github.com) y crear nuevo repositorio
2. Nombre: `ftp-manager` (o tu preferido)
3. Hacerlo **Público**
4. ✅ Marcar "Add a README file"

### 1.2 Subir archivos
Opción A - Por web:
1. Ir al repositorio creado
2. Click "Add file" → "Upload files"
3. Subir todos los archivos de esta carpeta (incluyendo `render.yaml`)

Opción B - Por terminal:
```bash
git init
git add .
git commit -m "FTP Manager v4.1 - Ready for Render"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/ftp-manager.git
git push -u origin main
```

---

## 🚀 PASO 2: Desplegar en Render

### 2.1 Crear cuenta
1. Ir a [render.com](https://render.com)
2. Click "Get Started for Free"
3. Registrarse con **GitHub** (más fácil) o email
4. ✅ **No requiere tarjeta de crédito**

### 2.2 Crear nuevo servicio
1. En dashboard, click **"New +"** → **"Web Service"**
2. Seleccionar **"Build and deploy from a Git repository"**
3. Conectar con GitHub y seleccionar el repositorio `ftp-manager`
4. Click **"Connect"**

### 2.3 Configurar el servicio
Render detectará automáticamente el archivo `render.yaml`, pero verifica estos valores:

| Campo | Valor |
|-------|-------|
| **Name** | `ftp-manager` |
| **Region** | `Frankfurt (EU Central)` o `Oregon (US West)` |
| **Branch** | `main` |
| **Runtime** | `Node` |
| **Build Command** | `npm install` |
| **Start Command** | `node server.js` |
| **Plan** | `Free` |

### 2.4 Variables de entorno (IMPORTANTE)
En la sección "Environment Variables", añadir:

```
NODE_VERSION=18
NODE_ENV=production
JWT_SECRET=tu-clave-secreta-muy-larga-aqui-minimo-32-caracteres
PORT=10000
FTP_HOST=82.98.168.246
FTP_USER=tu-usuario-ftp
FTP_PASS=tu-contraseña-ftp
FTP_PORT=21
```

⚠️ **IMPORTANTE**: Cambia `JWT_SECRET` por una clave larga y aleatoria (mínimo 32 caracteres)

### 2.5 Crear disco persistente (para users.json)
1. En la configuración del servicio, buscar "Disks"
2. Click "Create Disk"
3. **Name**: `data`
4. **Mount Path**: `/app/data`
5. **Size**: `0.5 GB` (mínimo gratis)

### 2.6 Deploy
1. Click **"Create Web Service"**
2. Esperar 3-5 minutos a que construya y despliegue
3. Ver en los logs: `✅ FTP Manager v4.1 en puerto 10000`
4. La URL será: `https://ftp-manager-xxx.onrender.com`

---

## ⏰ PASO 3: Configurar UptimeRobot (Evitar que se duerma)

Render "duerme" la app después de **15 minutos sin tráfico**. Para mantenerla 24/7 activa:

### 3.1 Crear cuenta
1. Ir a [uptimerobot.com](https://uptimerobot.com)
2. Click "Sign-up for FREE!"
3. Registrarse con email (confirmar email)

### 3.2 Crear monitor
1. Click **"Add New Monitor"**
2. Configurar:
   - **Monitor Type**: `HTTP(s)`
   - **Friendly Name**: `FTP Manager Health`
   - **URL**: `https://tu-app.onrender.com/api/health`
   - **Monitoring Interval**: `5 minutes` (opción gratis)
3. Click **"Create Monitor"**

### 3.3 Opcional - Configurar alertas
- En "Alert Contacts" puedes añadir email para notificaciones si la app cae

### ✅ Resultado
UptimeRobot hará ping cada 5 minutos a tu app, manteniéndola activa **24/7 sin costo**.

---

## 📊 Cuotas y Límites (Plan Gratuito Render)

| Recurso | Límite |
|---------|--------|
| **RAM** | 512 MB |
| **CPU** | 0.1 (compartido) |
| **Disco** | 0.5 GB (persistente) |
| **Transferencia** | 100 GB/mes |
| **Sleep** | Después de 15 min sin tráfico (evitado con UptimeRobot) |

---

## 🔧 Troubleshooting

### La app no arranca
- Verificar que `render.yaml` tiene sintaxis correcta
- Revisar logs en Render: "Logs" tab
- Asegurar que `npm install` no da errores

### Error de conexión FTP
- Verificar que las variables `FTP_HOST`, `FTP_USER`, `FTP_PASS` están correctas
- El servidor FTP debe permitir conexiones pasivas
- Verificar que el puerto 21 está abierto

### El disco no guarda datos
- Verificar que el disco está montado en `/app/data`
- Asegurar que la app escribe en esa ruta

### La app se duerme a pesar de UptimeRobot
- Verificar que la URL en UptimeRobot es correcta
- Revisar que el endpoint `/api/health` responde 200
- Cambiar intervalo a 5 minutos (más frecuente)

---

## 📝 Notas importantes

1. **Datos persistentes**: El archivo `data/users.json` se guarda en el disco montado. Si no creas el disco, los usuarios se borrarán al reiniciar.

2. **FTP**: La app se conecta a tu servidor FTP externo (configurado en variables de entorno). Render no incluye servidor FTP.

3. **Seguridad**: Nunca subas el archivo `.env` con credenciales a GitHub. Usa las variables de entorno de Render.

4. **SSL**: Render proporciona HTTPS automáticamente. La conexión FTP en el código está configurada sin SSL (`secure: false`). Si tu FTP requiere SSL, modificar en `server.js`.

---

## 📞 URLs útiles

- **Dashboard Render**: https://dashboard.render.com
- **Dashboard UptimeRobot**: https://uptimerobot.com/dashboard
- **Documentación Render**: https://render.com/docs
- **Health Check**: `https://tu-app.onrender.com/api/health`

---

## ✅ Checklist pre-deployment

- [ ] Repositorio en GitHub público
- [ ] Archivo `render.yaml` incluido
- [ ] Archivo `server.js` modificado con endpoint `/api/health`
- [ ] Variables de entorno configuradas en Render
- [ ] Disco persistente creado (`/app/data`)
- [ ] UptimeRobot configurado con URL correcta
- [ ] Probar acceso a la aplicación
- [ ] Verificar conexión FTP funciona

---

**Fecha preparación**: Abril 2025
**Versión**: 4.1.0
**Autor**: Original + Adaptación para Render
