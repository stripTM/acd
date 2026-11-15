#!/bin/sh
set -e

# Instala dependencias si el directorio vendor no existe (código montado desde el host)
if [ ! -f vendor/autoload.php ]; then
  composer install --no-interaction --prefer-dist
fi

# Único directorio de datos en ficheros: binarios subidos (el resto está en MongoDB)
mkdir -p data/contents
chown www-data:www-data data/contents 2>/dev/null || true

exec docker-php-entrypoint "$@"
