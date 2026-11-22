<p align="center"><img src="public/style/brand/acd-logo.svg" alt="ACD · Administrador de Contenidos Dinámicos" width="320"/></p>

# README #

Autogestor de contenidos dinámicos (ACD)

### What is this repository for? ###

* Realizar una herramienta que permita disponer de editores para la gestión de información persistente variable sin una estructura predefinida de antemano,  por ejemplo las típicas configuraciones necesarias en un proyecto, pequeños gestores de contenidos, que se adapten a las necesidades de un equipo de trabajo.

Para ello se creará un formulario para que el usuario final pueda mantener esa información fácilmente sin ningún conocimiento técnico.

Se dispondrá de un API de consulta y modificación de los datos almacenados tras definir en unos pocos pasos la estructura de datos a almacenar.
* Version 0.1
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up? ###

* Summary of set up
* Configuration
* Dependencies
* Database configuration
* How to run tests
* Deployment instructions

### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact

### LICENSE ###
Autogestor de contenidos dinámicos (ACD) files

ACD by stripTM All code is under GPL3: 
http://www.gnu.org/licenses/gpl-3.0.html

The images are under Creative Commons BY-SA 3.0:
http://creativecommons.org/licenses/by-sa/3.0/deed.es

### Entorno Docker (PHP 8.5 + MongoDB 8.0) ###

```sh
docker compose up -d --build   # http://localhost:8080  (usuario admin / admin)
docker compose logs -f app     # errores y avisos de PHP
docker compose down            # parar (los datos se conservan en data/)
```

* `docker/php/`: imagen PHP 8.5 + Apache con las extensiones `mongodb`, `imagick` y `tidy`. El código se monta desde el host y `composer install` se ejecuta al arrancar si falta `vendor/`.
* `docker/acd.env`: configuración de la app dentro del contenedor (se monta como `.env`).
* `docker/mongo/init/`: crea colecciones, índices y el usuario `admin` cuando `data/mongo` está vacío.
* `data/mongo`: ficheros de la base de datos MongoDB. Para empezar de cero, parar los contenedores y borrar este directorio (necesita `sudo`: los ficheros son del usuario de MongoDB, UID 999).
* `data/contents`: binarios subidos en los campos de tipo fichero.
* Copia de seguridad: `docker compose exec mongo mongodump --db acd --archive > acd.dump` (restaurar con `docker compose exec -T mongo mongorestore --archive < acd.dump`).
* Puertos configurables con `ACD_HTTP_PORT` (8080) y `ACD_MONGO_PORT` (27017, solo en localhost).

### Tests ###

```sh
docker compose exec app vendor/bin/phpunit
```

Usan la base de datos `acd_test` del mismo MongoDB, que se vacía y se carga con los datos de `tests/data` antes de cada test (no tocan la base de datos `acd`). Fallan ante cualquier aviso o deprecación de PHP.
