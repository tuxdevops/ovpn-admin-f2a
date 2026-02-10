# Instrucciones de Uso - VPN con 2FA

## Configuración completada exitosamente

El problema ha sido resuelto. Ahora la VPN requiere autenticación de dos factores (2FA) correctamente.

## ¿Cómo funciona?

1. **Creación de usuario**: Se genera automáticamente un secreto TOTP para Google Authenticator
2. **QR Code**: Puedes descargar el código QR desde la interfaz web
3. **Conexión**: Debes ingresar `password+token` (ej: `mipassword123456`)

## Pasos para el usuario final:

### 1. Configurar Google Authenticator
- Descarga la configuración QR desde ovpn-admin (botón "Download QR Code")
- Escanea el QR con Google Authenticator o similar
- Obtendrás códigos de 6 dígitos que se renuevan cada 30 segundos

### 2. Conectarse a la VPN
Cuando te pida credenciales, ingresa:
```
Username: tuusuario
Password: tupassword+token6digitos
```

**Ejemplo:**
- Si tu password es: `mipass123`
- Y el token actual es: `788983`
- Ingresa: `mipass123788983`

### 3. Configuración del cliente OpenVPN
La configuración descargada ya incluye:
- `auth-user-pass` - Habilita autenticación por usuario/contraseña
- `auth-nocache` - No cachea credenciales por seguridad
- `reneg-sec 0` - Renegociación para solicitar 2FA

## Verificación

Para verificar que todo funciona:
1. Crea un usuario nuevo desde ovpn-admin
2. Descarga el QR y configúralo en Google Authenticator
3. Descarga la configuración .ovpn
4. Conéctate usando `password+token`

El sistema verificará:
1. ✅ Token TOTP válido (6 dígitos)
2. ✅ Password correcto
3. ✅ Usuario activo

## Solución implementada

- **Script de autenticación modificado**: Soporta 2FA con extracción correcta de token
- **Configuración OpenVPN actualizada**: Incluye parámetros necesarios
- **Generación QR automática**: Al crear usuarios o cambiar password
- **Validación completa**: Verifica password y token TOTP

La autenticación de dos factores ahora funciona correctamente.
