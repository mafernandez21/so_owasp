#!/bin/bash
# Configura la autenticacion local de "su" con PAM (ejecutar como root).
#   ./pam_setup.sh            -> modo vulnerable: sin limite de intentos
#   ./pam_setup.sh --secure   -> modo mitigado: pam_faillock bloquea la cuenta
set -euo pipefail
[ "$(id -u)" -eq 0 ] || { echo "Ejecutar como root"; exit 1; }

# Contrasena debil (esta en diccionario.txt) para la cuenta atacada
echo "alumno:sunshine" | chpasswd

# Respaldo de la configuracion original de su
[ -f /etc/pam.d/su.orig ] || cp /etc/pam.d/su /etc/pam.d/su.orig
faillock --user alumno --reset 2>/dev/null || true

if [ "${1:-}" = "--secure" ]; then
    cat > /etc/security/faillock.conf <<'CONF'
# Bloquear la cuenta tras 3 intentos fallidos durante 5 minutos
deny = 3
unlock_time = 300
fail_interval = 900
audit
CONF
    cat > /etc/pam.d/su <<'PAM'
# root puede usar su sin contrasena
auth       sufficient pam_rootok.so
# pam_faillock: antes de verificar la contrasena revisa si la cuenta esta bloqueada,
# cuenta cada fallo y reinicia el contador ante un exito
auth       required   pam_faillock.so preauth
auth       [success=1 default=ignore] pam_unix.so
auth       [default=die] pam_faillock.so authfail
auth       sufficient pam_faillock.so authsucc
auth       requisite  pam_deny.so
account    required   pam_faillock.so
@include common-account
@include common-session
PAM
    echo "PAM mitigado: su bloquea la cuenta tras 3 intentos fallidos (ver /etc/pam.d/su)."
else
    cp /etc/pam.d/su.orig /etc/pam.d/su
    echo "PAM vulnerable: su no limita los intentos fallidos (configuracion por defecto)."
fi
