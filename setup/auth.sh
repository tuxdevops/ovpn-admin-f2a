#!/usr/bin/env sh

PATH=$PATH:/usr/local/bin
set -e

env

auth_usr=$(head -1 $1)
auth_passwd=$(tail -1 $1)

if [ $common_name = $auth_usr ]; then
  # Verificar 2FA si existe el archivo
  if [ -f "/etc/google-auth/${auth_usr}" ]; then
    # Extraer el token del password (formato: password+6digitos)
    token=$(echo "$auth_passwd" | grep -o '[0-9]\{6\}$')
    password=$(echo "$auth_passwd" | sed 's/[0-9]\{6\}$//')
    
    if [ -n "$token" ]; then
      # Primero verificar 2FA
      if google-authenticator --time-based --disallow-reuse --force \
        --secret="/etc/google-auth/${auth_usr}" \
        --window-size=3 \
        --rate-limit=3 --rate-time=30 \
        "$token" 2>/dev/null; then
        # Si 2FA es válido, verificar password
        openvpn-user auth --db.path /etc/openvpn/easyrsa/pki/users.db --user ${auth_usr} --password ${password}
      else
        echo "Invalid 2FA token"
        exit 1
      fi
    else
      echo "2FA token required"
      exit 1
    fi
  else
    # Solo password si no hay 2FA configurado
    openvpn-user auth --db.path /etc/openvpn/easyrsa/pki/users.db --user ${auth_usr} --password ${auth_passwd}
  fi
else
  echo "Authorization failed"
  exit 1
fi
