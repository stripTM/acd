#!/bin/sh
set -e

# Instala dependencias si el directorio vendor no existe (código montado desde el host)
if [ ! -f vendor/autoload.php ]; then
  composer install --no-interaction --prefer-dist
fi

# Directorios de datos en ficheros (permisos, credenciales, binarios subidos)
mkdir -p data/structures data/contents data/auth_permanent_login
chown -R www-data:www-data data/contents data/auth_permanent_login 2>/dev/null || true

exec docker-php-entrypoint "$@"
