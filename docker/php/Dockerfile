# Imagen de ejecución de ACD: PHP 8.5 + Apache + extensión MongoDB
FROM php:8.5-apache

ARG MONGODB_EXT_VERSION=2.5.7

RUN apt-get update \
 && apt-get install -y --no-install-recommends git unzip libssl-dev libzip-dev \
 && pecl install mongodb-${MONGODB_EXT_VERSION} \
 && docker-php-ext-enable mongodb \
 && docker-php-ext-install zip \
 && a2enmod rewrite headers \
 && rm -rf /var/lib/apt/lists/* /tmp/pear

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# DocumentRoot en public/
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
 && sed -ri 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY php.ini /usr/local/etc/php/conf.d/zz-acd.ini
COPY entrypoint.sh /usr/local/bin/acd-entrypoint
RUN chmod +x /usr/local/bin/acd-entrypoint

WORKDIR /var/www/html
ENTRYPOINT ["acd-entrypoint"]
CMD ["apache2-foreground"]
